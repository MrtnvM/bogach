import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/core/errors/purchase_errors.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/models/errors/past_purchase_error.dart';
import 'package:cash_flow/models/errors/products_not_found_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/rxdart.dart';

class PurchaseService {
  PurchaseService();

  final _connection = InAppPurchaseConnection.instance;

  /// Subscribe to any incoming purchases at app initialization. These can
  /// propagate from either storefront.
  Stream<BuiltList<PurchaseDetails>> listenPurchaseUpdates() {
    // TODO(Artem): Handle new purchases on the mobile side.
    return _connection.purchaseUpdatedStream
        .map((items) => items.toBuiltList());
  }

  Stream<bool> isAvailable() {
    return Stream.fromFuture(_connection.isAvailable());
  }

  Stream<BuiltList<ProductDetails>> queryProductDetails({
    Set<String> ids,
  }) {
    return Stream.fromFuture(_connection.queryProductDetails(ids))
        .map((response) {
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
  Stream<BuiltList<PurchaseDetails>> queryPastPurchases() {
    return Stream.fromFuture(_connection.queryPastPurchases())
        .flatMap((response) {
      if (response.error != null) {
        return Stream.error(PastPurchaseError(response.error.code));
      }

      // TODO(Artem): _verifyPurchase(purchase);

      if (Platform.isIOS) {
        return Stream.fromFutures(
                response.pastPurchases.map(_connection.completePurchase))
            .map((_) => response.pastPurchases.toBuiltList());
      }

      return Stream.value(response.pastPurchases.toBuiltList());
    });
  }

  /// To restore consumable purchases across devices, you should keep track of
  /// those purchase on your own server and restore the purchase for your users.
  /// Consumed products are no longer considered to be "owned" by payment
  /// platforms and will not be delivered by calling [queryPastPurchases].
  // TODO(Artem): Persist purchases on our server
  Stream<bool> buyConsumable({@required ProductDetails productDetails}) {
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    return Stream.fromFuture(_connection.buyConsumable(
      purchaseParam: purchaseParam,
    ));
  }

  Stream<bool> buyNonConsumable({@required ProductDetails productDetails}) {
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    return Stream.fromFuture(_connection.buyNonConsumable(
      purchaseParam: purchaseParam,
    ));
  }

  Future<void> buyQuestsAcceess() async {
    final response = await InAppPurchaseConnection.instance.queryProductDetails(
      {questsAccessProductId},
    );

    if (response.notFoundIDs.isNotEmpty) {
      throw NoInAppPurchaseProductsError();
    }

    final product = response.productDetails.first;

    final pastPurchasesResponse =
        await InAppPurchaseConnection.instance.queryPastPurchases();

    if (response.error != null) {
      throw QueryPastPurchasesRequestError(response.error);
    }

    for (final purchase in pastPurchasesResponse.pastPurchases) {
      if (purchase.productID == questsAccessProductId) {
        // Deliver the purchase to the user in your app.

        if (Platform.isIOS) {
          // Mark that you've delivered the purchase.
          // Only the App Store requires
          // this final confirmation.
          InAppPurchaseConnection.instance.completePurchase(purchase);
        }

        return;
      }
    }

    InAppPurchaseConnection.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );

    return _connection.purchaseUpdatedStream
        .map(
          (products) => products.firstWhere(
            (p) => p.productID == questsAccessProductId,
            orElse: () => null,
          ),
        )
        .firstWhere((p) => p != null);
  }
}
