import 'dart:async';

import 'package:cash_flow/models/domain/user/purchase_profile.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/models/network/request/purchases/purchase_details_request_model.dart';
import 'package:cash_flow/models/network/request/purchases/update_purchases_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';

class PurchaseService {
  PurchaseService({
    @required CashFlowApiClient apiClient,
    @required InAppPurchaseConnection connection,
  })  : _connection = connection,
        _apiClient = apiClient;

  final CashFlowApiClient _apiClient;
  final InAppPurchaseConnection _connection;

  final _currentPurchasingProductIds = <String>[];
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
      final notCurrentllyPurchasingProducts = purchases //
          .where((p) => !_currentPurchasingProductIds.contains(p.productID))
          .toList();

      _completePurchasesIfNeeded(
        notCurrentllyPurchasingProducts,
        withRetry: true,
      );
    });

    /// Fix of async nature of subscription to Streams
    /// If we want to get values from [purchaseUpdatedStream] with [purchases]
    /// stream immeadetely we will fail because listening called
    /// asyncroniosly and happend on next event loop cycles
    ///
    /// Needed for tests
    await Future.delayed(const Duration(milliseconds: 1));
  }

  Future<bool> isAvailable() {
    return _connection.isAvailable();
  }

  Future<List<PurchaseDetails>> queryPastPurchases() async {
    final response = await _connection.queryPastPurchases();

    if (response.error != null) {
      Logger.e('Query of Past Purchases failed: ${response.error}');
      throw QueryPastPurchasesRequestError(response.error);
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
    return _connection.buyConsumable(purchaseParam: purchaseParams);
  }

  Future<bool> buyNonConsumable({@required ProductDetails productDetails}) {
    final purchaseParams = PurchaseParam(productDetails: productDetails);
    return _connection.buyNonConsumable(purchaseParam: purchaseParams);
  }

  Future<List<ProductDetails>> queryProductDetails({Set<String> ids}) {
    return _connection.queryProductDetails(ids).then((response) {
      if (response.notFoundIDs.isNotEmpty) {
        throw NoInAppPurchaseProductsError(response.notFoundIDs);
      }

      return response.productDetails;
    });
  }

  Future<ProductDetails> getProduct(String productId) async {
    final response = await _connection.queryProductDetails({productId});

    if (response.notFoundIDs.isNotEmpty) {
      throw NoInAppPurchaseProductsError(response.notFoundIDs);
    }

    final product = response.productDetails.first;
    return product;
  }

  Future<PurchaseProfile> buyNonConsumableProduct({
    @required String productId,
    @required String userId,
  }) async {
    try {
      _currentPurchasingProductIds.add(productId);

      Logger.i('Loading product ($productId)');
      final product = await getProduct(productId);
      Logger.i(
        'Product ($productId) loaded: ${product.title} - ${product.price}',
      );

      Logger.i('Buying non consumable product ($productId)');
      final result = await _connection.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );

      if (result) {
        Logger.i('Non consumable product ($productId) successfully bought');
      } else {
        Logger.i('Non consumable product ($productId) purchase failed');
        throw ProductPurchaseFailedError(product);
      }

      Logger.i('Waiting purchase details for product ($productId)');
      final purchase = await _getPurchase(productId: productId);
      _logPurchase(purchase);

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
      _currentPurchasingProductIds.remove(productId);
    }
  }

  Future<PurchaseProfile> buyConsumableProduct({
    @required String productId,
    @required String userId,
  }) async {
    try {
      _currentPurchasingProductIds.add(productId);

      Logger.i('Loading product ($productId)');
      final product = await getProduct(productId);
      Logger.i(
        'Product ($productId) loaded: ${product.title} - ${product.price}',
      );

      Logger.i('Buying consumable product ($productId)');
      final result = await _connection.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );

      if (result) {
        Logger.i('Consumable product ($productId) successfully bought');
      } else {
        Logger.i('Consumable product ($productId) purchase failed');
        throw ProductPurchaseFailedError(product);
      }

      Logger.i('Waiting purchase details for product ($productId)');
      final purchase = await _getPurchase(productId: productId);
      _logPurchase(purchase);

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
      _currentPurchasingProductIds.remove(productId);
    }
  }

  Future<PurchaseProfile> buyQuestsAcceess(String userId) async {
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

    final purchaseProfile = await _apiClient.sendPurchasedProducts(
      UpdatePurchasesRequestModel(
        userId: userId,
        purchases: completedPurchases,
      ),
    );

    return purchaseProfile;
  }

  Future<List<PurchaseDetails>> _completePurchasesIfNeeded(
    List<PurchaseDetails> purchases, {
    bool withRetry = false,
  }) async {
    Logger.i('Started completion of purchases...');

    final notCompletedPurchases = purchases //
        .where((p) => p.pendingCompletePurchase)
        .toList();

    if (notCompletedPurchases.isEmpty) {
      Logger.i('Purchases already completed');
      return [];
    }

    final notCompletedPurchasesIds = notCompletedPurchases //
        .map((p) => p.purchaseID)
        .toList();
    Logger.i('Completing purchases: $notCompletedPurchasesIds');

    final results = await Future.wait([
      for (final purchase in notCompletedPurchases)
        _connection.completePurchase(purchase),
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

    if (withRetry) {
      Future.delayed(const Duration(minutes: 1)).then((_) {
        final failedToCompletePurchasesIds = failedToCompletePurchases //
            .map((p) => p.purchaseID)
            .toList();

        Logger.i(
          'Retrying to complete purchases: $failedToCompletePurchasesIds',
        );

        _completePurchasesIfNeeded(failedToCompletePurchases);
      });
    }

    final failedToCompletePurchasesIds = failedToCompletePurchases //
        .map((p) => p.purchaseID)
        .toList();

    Logger.i(
      'Failed to complete purchases: $failedToCompletePurchasesIds',
    );

    return failedToCompletePurchases;
  }

  void _updatePurchases(List<PurchaseDetails> purchases) {
    final currentPurchases = _purchases.value;
    final updatedPurchases = {...currentPurchases};

    for (final purchase in purchases) {
      updatedPurchases[purchase.purchaseID] = purchase;
    }

    _purchases.value = updatedPurchases;
  }

  Future<PurchaseDetails> _getPurchase({@required String productId}) {
    return purchases
        .map((purchases) => purchases.firstWhere(
              (p) => p.productID == productId,
              orElse: () => null,
            ))
        .where((p) => p != null)
        .first;
  }

  void _logPurchase(PurchaseDetails purchase) {
    Logger.i(
      'Purchase details for product (${purchase.productID}): '
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
