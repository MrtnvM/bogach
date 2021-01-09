import 'dart:async';

import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/models/domain/user/purchase_profile.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/models/network/request/purchases/purchase_details_request_model.dart';
import 'package:cash_flow/models/network/request/purchases/update_purchases_request_model.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/rxdart.dart';

class PurchaseService {
  PurchaseService({
    @required CashFlowApiClient apiClient,
    @required InAppPurchaseConnection connection,
  })  : _connection = connection,
        _apiClient = apiClient;

  final CashFlowApiClient _apiClient;
  final InAppPurchaseConnection _connection;

  String _currentPurchasingProduct;
  final _pastPurchases = BehaviorSubject<List<PurchaseDetails>>.seeded([]);
  final _purchases = BehaviorSubject<Map<String, PurchaseDetails>>.seeded({});

  Stream<List<PurchaseDetails>> get purchases =>
      _purchases.stream.map((p) => p.values.toList());

  Stream<List<PurchaseDetails>> get pastPurchases => _pastPurchases.stream;

  /// Subscribe to any incoming purchases at app initialization
  Future<void> startListeningPurchaseUpdates() async {
    _connection.purchaseUpdatedStream.listen((purchases) {
      _updatePurchases(purchases);

      /// Filter only products that not is currently buying
      /// So we can track the status on a purchase in the method
      /// that performing the purchase
      final notCurrentlyPurchasingProducts = purchases //
          .where((p) => _currentPurchasingProduct != p.productID)
          .toList();

      if (notCurrentlyPurchasingProducts.isNotEmpty) {
        _completePurchasesIfNeeded(
          notCurrentlyPurchasingProducts,
          withRetry: true,
        );
      }
    });

    /// Fix of async nature of subscription to Streams
    /// If we want to get values from [purchaseUpdatedStream] with [purchases]
    /// stream immediately we will fail because listening called
    /// asynchronously and happened on next event loop cycles
    ///
    /// Needed for tests
    await Future.delayed(const Duration(milliseconds: 1));
  }

  Future<bool> isAvailable() {
    return _connection.isAvailable().catchError(recordError);
  }

  Future<List<PurchaseDetails>> queryPastPurchases() async {
    final response =
        await _connection.queryPastPurchases().catchError(recordError);

    if (response.error != null) {
      Logger.e('Query of Past Purchases failed: ${response.error}');
      throw QueryPastPurchasesRequestException(response.error);
    }

    final pastPurchases = response.pastPurchases;
    return pastPurchases;
  }

  Future<PurchaseProfile> restorePastPurchases(String userId) async {
    Logger.i('Restoring past purchases started for user ($userId)');
    final pastPurchases = await queryPastPurchases();
    Logger.i('Restored purchases:');
    pastPurchases.forEach(_logPurchase);

    // TODO(Maxim): _verifyPurchase(purchase);

    Logger.i('Sending purchases to server...');
    final purchaseProfile = await _sendPurchasesToServer(userId, pastPurchases);
    Logger.i('Purchase Profile:\n$purchaseProfile');

    await _completePurchasesIfNeeded(pastPurchases);

    final completedPurchases = pastPurchases //
        .where((p) => p.status == PurchaseStatus.purchased)
        .toList();

    if (completedPurchases.isNotEmpty) {
      _pastPurchases.add(completedPurchases);
    }

    return purchaseProfile;
  }

  Future<bool> buyConsumable({@required ProductDetails productDetails}) {
    final purchaseParams = PurchaseParam(productDetails: productDetails);
    return _connection
        .buyConsumable(purchaseParam: purchaseParams)
        .catchError(recordError);
  }

  Future<bool> buyNonConsumable({@required ProductDetails productDetails}) {
    final purchaseParams = PurchaseParam(productDetails: productDetails);
    return _connection
        .buyNonConsumable(purchaseParam: purchaseParams)
        .catchError(recordError);
  }

  Future<List<ProductDetails>> queryProductDetails({Set<String> ids}) {
    return _connection.queryProductDetails(ids).then((response) {
      if (response.notFoundIDs.isNotEmpty) {
        throw NoInAppPurchaseProductsException(response.notFoundIDs);
      }

      return response.productDetails;
    }).catchError(recordError);
  }

  Future<ProductDetails> getProduct(String productId) async {
    final response = await _connection
        .queryProductDetails({productId}).catchError(recordError);

    if (response.notFoundIDs.isNotEmpty) {
      throw NoInAppPurchaseProductsException(response.notFoundIDs);
    }

    final product = response.productDetails.first;
    return product;
  }

  Future<PurchaseProfile> buyNonConsumableProduct({
    @required String productId,
    @required String userId,
  }) async {
    try {
      _currentPurchasingProduct = productId;

      Logger.i('Loading product ($productId)');
      final product = await getProduct(productId);
      Logger.i(
        'Product ($productId) loaded: ${product.title} - ${product.price}',
      );

      Logger.i('Buying non consumable product ($productId)');
      await _connection
          .buyNonConsumable(
            purchaseParam: PurchaseParam(productDetails: product),
          )
          .catchError(recordError);

      Logger.i('Waiting purchase details for product ($productId)');
      final purchase = await _getPurchase(productId: productId);
      _logPurchase(purchase);

      if (purchase.status == PurchaseStatus.error) {
        _completePurchasesIfNeeded([purchase], withRetry: true);

        if (purchase.purchaseID == null) {
          throw ProductPurchaseCanceledException(product);
        } else {
          throw ProductPurchaseFailedException(product);
        }
      }

      Logger.i('Sending purchase for product ($productId) to server');
      final purchaseProfile = await _sendPurchasesToServer(userId, [purchase])
          .timeout(const Duration(seconds: 60));
      Logger.i('Purchase for product ($productId) uploaded to server');

      try {
        Logger.i('Completing purchase for product $productId');

        final completionResult = await _completePurchasesIfNeeded(
          [purchase],
          withRetry: true,
        );

        if (completionResult.isEmpty) {
          Logger.i('Completion purchase for product $productId succeed');
        } else {
          Logger.i('Completion purchase for product $productId failed');
        }
      } catch (error) {
        Logger.e('Failed to complete purchase for product $productId: $error');
      }

      return purchaseProfile;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      Logger.e('Error on buying product ($productId): $error');
      rethrow;
    } finally {
      _currentPurchasingProduct = null;
    }
  }

  Future<PurchaseProfile> buyConsumableProduct({
    @required String productId,
    @required String userId,
  }) async {
    try {
      _currentPurchasingProduct = productId;

      Logger.i('Loading product ($productId)');
      final product = await getProduct(productId);
      Logger.i(
        'Product ($productId) loaded: ${product.title} - ${product.price}',
      );

      Logger.i('Buying consumable product ($productId)');
      await _connection
          .buyConsumable(
            purchaseParam: PurchaseParam(productDetails: product),
          )
          .catchError(recordError);

      Logger.i('Waiting purchase details for product ($productId)');
      final purchase = await _getPurchase(productId: productId);
      _logPurchase(purchase);

      if (purchase.status == PurchaseStatus.error) {
        _completePurchasesIfNeeded([purchase], withRetry: true);

        if (purchase.purchaseID == null) {
          throw ProductPurchaseCanceledException(product);
        } else {
          throw ProductPurchaseFailedException(product);
        }
      }

      Logger.i('Sending purchase for product ($productId) to server');
      final purchaseProfile = await _sendPurchasesToServer(userId, [purchase])
          .timeout(const Duration(seconds: 60));
      Logger.i('Purchase for product ($productId) uploaded to server');

      Logger.i('Completing purchase for product $productId');
      final completionResult = await _completePurchasesIfNeeded(
        [purchase],
        withRetry: true,
      );

      if (completionResult.isEmpty) {
        Logger.i('Completion purchase for product $productId succeed');
      } else {
        Logger.i('Completion purchase for product $productId failed');
      }

      return purchaseProfile;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      Logger.e('Error on buying product ($productId): $error');
      rethrow;
    } finally {
      _currentPurchasingProduct = null;
    }
  }

  Future<PurchaseProfile> buyQuestsAccess(String userId) async {
    final purchaseProfile = await restorePastPurchases(userId);

    if (purchaseProfile.isQuestsAvailable) {
      return purchaseProfile;
    }

    final updatedPurchaseProfile = await buyNonConsumableProduct(
      productId: questsAccessProductId,
      userId: userId,
    );

    return updatedPurchaseProfile;
  }

  Future<PurchaseProfile> buyMultiplayerGames({
    @required MultiplayerGamePurchases purchase,
    @required String userId,
  }) {
    final productId = purchase.productId;

    return buyConsumableProduct(
      productId: productId,
      userId: userId,
    );
  }

  Future<PurchaseProfile> _sendPurchasesToServer(
    String userId,
    List<PurchaseDetails> purchases,
  ) async {
    final completedPurchases = purchases //
        .where((p) => p.status == PurchaseStatus.purchased)
        .map(
          (p) => PurchaseDetailsRequestModel(
            productId: p.productID,
            purchaseId: p.purchaseID,
            verificationData: p.verificationData?.serverVerificationData,
            source: p.verificationData?.source?.toString(),
          ),
        )
        .toList();

    if (completedPurchases.isEmpty) {
      return null;
    }

    final purchaseProfile = await _apiClient
        .sendPurchasedProducts(
          UpdatePurchasesRequestModel(
            userId: userId,
            purchases: completedPurchases,
          ),
        )
        .catchError(recordError);

    return purchaseProfile;
  }

  Future<List<PurchaseDetails>> _completePurchasesIfNeeded(
    List<PurchaseDetails> purchases, {
    bool withRetry = false,
  }) async {
    final purchasesIds = purchases.map((p) => p.productID).toList();
    Logger.i('Started completion of purchases ($purchasesIds)...');

    final notCompletedPurchases = purchases //
        .where((p) => p.pendingCompletePurchase == true)
        .toList();

    if (notCompletedPurchases.isEmpty) {
      Logger.i('No purchases to complete');
      return [];
    }

    final notCompletedPurchasesIds = notCompletedPurchases //
        .map((p) => p.productID)
        .toList();
    Logger.i('Completing purchases: $notCompletedPurchasesIds');

    final results = await Future.wait([
      for (final purchase in notCompletedPurchases)
        _connection.completePurchase(purchase).catchError(recordError),
    ]);

    final retryStatuses = [
      BillingResponse.billingUnavailable,
      BillingResponse.error,
      BillingResponse.serviceDisconnected,
      BillingResponse.serviceUnavailable,
    ];

    // ignore: omit_local_variable_types
    final List<PurchaseDetails> failedToCompletePurchases = [];

    for (var i = 0; i < results.length; i++) {
      final purchase = notCompletedPurchases[i];
      final result = results[i];

      if (retryStatuses.contains(result.responseCode)) {
        failedToCompletePurchases.add(purchase);
      }
    }

    if (withRetry && failedToCompletePurchases.isNotEmpty) {
      Future.delayed(const Duration(minutes: 1)).then((_) {
        final failedToCompletePurchasesIds = failedToCompletePurchases //
            .map((p) => p.productID)
            .toList();

        Logger.i(
          'Retrying to complete purchases: $failedToCompletePurchasesIds',
        );

        _completePurchasesIfNeeded(failedToCompletePurchases);
      });
    }

    final failedToCompletePurchasesIds = failedToCompletePurchases //
        .map((p) => p.productID)
        .toList();

    Logger.i(
      'Failed to complete purchases: $failedToCompletePurchasesIds',
    );

    return failedToCompletePurchases;
  }

  void _updatePurchases(List<PurchaseDetails> purchases) {
    final currentPurchases = _purchases.value;
    final updatedPurchases = {...currentPurchases};

    for (final p in purchases) {
      var purchase = p;

      /// On Android if purchase was canceled purchase has
      /// empty info fields even the product ID, so we are using saved
      /// product ID of the current purchase to fix the problem
      if (purchase.productID == null) {
        purchase = PurchaseDetails(
          purchaseID: null,
          productID: _currentPurchasingProduct,
          verificationData: null,
          transactionDate: null,
        )..status = PurchaseStatus.error;
      }

      updatedPurchases[purchase.productID] = purchase;
    }

    _purchases.value = updatedPurchases;
  }

  Future<PurchaseDetails> _getPurchase({@required String productId}) async {
    final purchase = await purchases
        .map((purchases) => purchases.firstWhere(
              (p) =>
                  p.productID == productId &&
                  [
                    PurchaseStatus.purchased,
                    PurchaseStatus.error,
                  ].contains(p.status),
              orElse: () => null,
            ))
        .where((p) => p != null)
        .first
        .catchError(recordError);

    final newPurchases = _purchases.value;
    newPurchases.remove(productId);
    _purchases.value = newPurchases;

    return purchase;
  }

  void _logPurchase(PurchaseDetails purchase) {
    Logger.i(
      'Purchase details for product (${purchase.productID}):\n'
      '  Purchase ID = ${purchase.purchaseID}\n'
      '  Purchase Status = ${purchase.status}\n'
      '  Pending completion = ${purchase.pendingCompletePurchase}\n'
      '  Server verification data = '
      '${purchase.verificationData?.serverVerificationData}\n'
      '  Local verification data = '
      '${purchase.verificationData?.localVerificationData}\n'
      '  Source = ${purchase.verificationData?.source}',
    );
  }
}
