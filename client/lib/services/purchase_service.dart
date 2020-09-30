import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/core/errors/purchase_errors.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/models/errors/products_not_found_error.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';

class PurchaseService {
  PurchaseService({@required this.apiClient});

  final CashFlowApiClient apiClient;
  final _connection = InAppPurchaseConnection.instance;
  final _pastPurchases = StreamController<List<PurchaseDetails>>();

  Stream<List<PurchaseDetails>> get pastPurchases => _pastPurchases.stream;

  /// Subscribe to any incoming purchases at app initialization. These can
  /// propagate from either storefront.
  Stream<List<PurchaseDetails>> listenPurchaseUpdates() {
    return _connection.purchaseUpdatedStream.doOnData((purchases) {
      _completeFailedPurchases(purchases);
      Logger.i('Purchase Updated Stream: $purchases');
    });
  }

  Future<bool> isAvailable() {
    return _connection.isAvailable();
  }

  Future<BuiltList<ProductDetails>> queryProductDetails({Set<String> ids}) {
    return _connection.queryProductDetails(ids).then((response) {
      if (response.notFoundIDs.isNotEmpty) {
        throw ProductsNotFoundError(response.notFoundIDs);
      }

      return response.productDetails.toBuiltList();
    });
  }

  /// Note that the App Store does not have any APIs for querying consumable
  /// products, and Google Play considers consumable products to no longer be
  /// owned once they're marked as consumed and fails to return them here. For
  /// restoring these across devices you'll need to persist them on your own
  /// server and query that as well.
  // TODO(Artem): Persist purchases on our server
  Future<BuiltList<PurchaseDetails>> queryPastPurchases(String userId) async {
    final response = await _connection.queryPastPurchases();

    if (response.error != null) {
      Logger.e('Query of Past Purchases failed: ${response.error}');
      throw QueryPastPurchasesRequestError(response.error);
    }

    final pastPurchases = response.pastPurchases;

    // TODO(Artem): _verifyPurchase(purchase);

    pastPurchases
        .where((p) => p.pendingCompletePurchase)
        .forEach(_connection.completePurchase);

    final completedPurchases = pastPurchases //
        .where((p) => p.status == PurchaseStatus.purchased)
        .toList();

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

    return pastPurchases.toBuiltList();
  }

  /// To restore consumable purchases across devices, you should keep track of
  /// those purchase on your own server and restore the purchase for your users.
  /// Consumed products are no longer considered to be "owned" by payment
  /// platforms and will not be delivered by calling [queryPastPurchases].
  // TODO(Artem): Persist purchases on our server
  Future<bool> buyConsumable({@required ProductDetails productDetails}) {
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    return _connection.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }

  Future<bool> buyNonConsumable({@required ProductDetails productDetails}) {
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    return _connection.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  Future<void> buyQuestsAcceess(String userId) async {
    final response = await _connection.queryProductDetails(
      {questsAccessProductId},
    );

    if (response.notFoundIDs.isNotEmpty) {
      throw NoInAppPurchaseProductsError();
    }

    final product = response.productDetails.first;
    final pastPurchases = await queryPastPurchases(userId);
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

    final completionResult = await _connection.completePurchase(purchase);
    Logger.i('Is purchase completed (${product.id}): $completionResult');

    await sendPurchasedProductsToServer(userId, [purchase])
        .timeout(const Duration(seconds: 30));

    Logger.i('Purchase (${product.id}) uploaded to server');
  }

  Future<void> sendPurchasedProductsToServer(
    String userId,
    List<PurchaseDetails> purchases,
  ) {
    final productIds = purchases //
        .map((p) => hashProductId(p.productID))
        .toList();

    return apiClient.sendPurchasedProducts(userId, productIds);
  }

  Future<void> _completeFailedPurchases(List<PurchaseDetails> purchases) async {
    if (!Platform.isIOS) {
      return;
    }

    final failedPurchases = purchases //
        .where((p) => p.status == PurchaseStatus.error)
        .toList();

    for (final purchase in failedPurchases) {
      try {
        final result = await _connection.completePurchase(purchase);

        final retryStatuses = [
          BillingResponse.billingUnavailable,
          BillingResponse.error,
          BillingResponse.serviceDisconnected,
          BillingResponse.serviceUnavailable,
        ];

        if (retryStatuses.contains(result.responseCode)) {
          Future.delayed(const Duration(minutes: 1)).then((_) {
            _completeFailedPurchases([purchase]);
          });
        }

        if (result.responseCode == BillingResponse.ok) {
          Logger.i('Purchase (${purchase.productID}) was completed!');
        }

        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        Logger.e('Can not complete purchase (${purchase.productID}): $error');
      }
    }
  }
}
