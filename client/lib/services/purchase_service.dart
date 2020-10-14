import 'dart:async';

import 'package:cash_flow/models/errors/purchase_errors.dart';
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

  final _pastPurchases = BehaviorSubject<List<PurchaseDetails>>.seeded([]);
  final _purchases = BehaviorSubject<Map<String, PurchaseDetails>>.seeded({});

  Stream<List<PurchaseDetails>> get purchases =>
      _purchases.stream.map((p) => p.values.toList());

  Stream<List<PurchaseDetails>> get pastPurchases => _pastPurchases.stream;

  /// Subscribe to any incoming purchases at app initialization
  Future<void> startListeningPurchaseUpdates() async {
    _connection.purchaseUpdatedStream.listen((purchases) {
      _updatePurchases(purchases);
      _completePurchasesIfNeeded(purchases, withRetry: true);
    });

    /// Fix of async nature of subscription to Streams
    /// If we want to get values from [purchaseUpdatedStream] immeadetely
    /// we will fail because listening called asyncroniosly and happend on
    /// next event loop cycles
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

  Future<void> restorePastPurchases(String userId) async {
    final pastPurchases = await queryPastPurchases();

    await _completePurchasesIfNeeded(pastPurchases);

    final completedPurchases = pastPurchases //
        .where((p) => p.status == PurchaseStatus.purchased)
        .toList();

    await sendPurchasedProductsToServer(userId, pastPurchases);

    // TODO(Artem): _verifyPurchase(purchase);

    if (completedPurchases.isNotEmpty) {
      if (userId != null) {
        sendPurchasedProductsToServer(userId, pastPurchases).then((_) {
          Logger.i('Past purchases successfuly uploaded to server');
        }).catchError((e) {
          Logger.e('Past purchases uploading failed: $e');
        });
      }

      _pastPurchases.add(completedPurchases);
    }

    return pastPurchases;
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

  Future<void> buyQuestsAcceess(String userId) async {
    final product = await getProduct(questsAccessProductId);

    final pastPurchases = await queryPastPurchases();
    final currentPurchase = pastPurchases.firstWhere(
      (p) => p.productID == product.id,
      orElse: () => null,
    );

    if (currentPurchase != null) {
      if (currentPurchase.pendingCompletePurchase) {
        await _connection.completePurchase(currentPurchase);
      }

      Logger.i('Purchase (${product.id}) already completed!');
      // Delivering the purchase to the user
      // By returning we indicates that purchase completed
      return;
    }

    final purchaseRequest = _connection.purchaseUpdatedStream
        .map(
          (products) => products.firstWhere(
            (p) => p.productID == product.id,
            orElse: () => null,
          ),
        )
        .where((p) => p != null)
        .timeout(const Duration(seconds: 30))
        .first;

    try {
      final result = await _connection.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );

      Logger.i('Purchase (${product.id}) result: $result');

      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      Logger.e('Error on buying product (${product.id}): $error');
      rethrow;
    }

    final purchase = await purchaseRequest;
    Logger.i('Purchasing (${product.id}): $purchase');

    await sendPurchasedProductsToServer(userId, [purchase])
        .timeout(const Duration(seconds: 30));

    Logger.i('Purchase (${product.id}) uploaded to server');

    final completionResult = await _connection.completePurchase(purchase);
    Logger.i('Is purchase completed (${product.id}): $completionResult');
  }

  Future<int> buyMultiplayerGames({
    @required String userId,
    @required String productId,
  }) async {
    final product = await getProduct(productId);

    final purchaseRequest = _connection.purchaseUpdatedStream
        .map(
          (purchases) => purchases.firstWhere(
            (p) => p.productID == product.id,
            orElse: () => null,
          ),
        )
        .where((p) => p != null)
        .timeout(const Duration(seconds: 30))
        .first;

    try {
      final result = await _connection.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );

      Logger.i('Purchase (${product.id}) result: $result');

      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      Logger.e('Error on buying product (${product.id}): $error');
      rethrow;
    }

    final purchase = await purchaseRequest;
    Logger.i('Purchasing (${product.id}): $purchase');

    await sendPurchasedProductsToServer(userId, [purchase])
        .timeout(const Duration(seconds: 30));
    Logger.i('Purchase (${product.id}) uploaded to server');

    final completionResult = await _connection.completePurchase(purchase);
    Logger.i('Is purchase completed (${product.id}): $completionResult');

    return getMultiplayerGamePurchaseFromId(purchase.productID).gamesCount;
  }

  Future<void> sendPurchasedProductsToServer(
    String userId,
    List<PurchaseDetails> purchases,
  ) {
    final productIds = purchases //
        .map((p) => hashProductId(p.productID))
        .toList();

    return _apiClient.sendPurchasedProducts(userId, productIds);
  }

  Future<List<PurchaseDetails>> _completePurchasesIfNeeded(
    List<PurchaseDetails> purchases, {
    bool withRetry = false,
  }) async {
    final notCompletedPurchases =
        purchases.where((p) => p.pendingCompletePurchase).toList();

    if (notCompletedPurchases.isEmpty) {
      return [];
    }

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
        _completePurchasesIfNeeded(failedToCompletePurchases);
      });
    }

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
}
