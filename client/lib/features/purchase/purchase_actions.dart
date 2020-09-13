import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' as material;
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class StartListeningPurchasesAction extends Action {
  StartListeningPurchasesAction();
}

class OnPurchasesUpdatedAction extends Action {
  OnPurchasesUpdatedAction(this.purchases);

  final List<PurchaseDetails> purchases;
}

class IsPurchasesAvailableAsyncAction extends AsyncAction<bool> {
  IsPurchasesAvailableAsyncAction();
}

class QueryProductsForSaleAsyncAction
    extends AsyncAction<BuiltList<ProductDetails>> {
  QueryProductsForSaleAsyncAction({
    @material.required this.ids,
  }) : assert(ids?.isNotEmpty == true);

  final Set<String> ids;
}

class QueryPastPurchasesAsyncAction
    extends AsyncAction<BuiltList<PurchaseDetails>> {
  QueryPastPurchasesAsyncAction();
}

class OnPastPurchasesRestoredAction extends Action {
  OnPastPurchasesRestoredAction(this.pastPurchases);

  final List<PurchaseDetails> pastPurchases;
}

class BuyConsumableAsyncAction extends AsyncAction<bool> {
  BuyConsumableAsyncAction({
    @material.required this.product,
  }) : assert(product != null);

  final ProductDetails product;
}

class BuyNonConsumableAsyncAction extends AsyncAction<bool> {
  BuyNonConsumableAsyncAction({
    @material.required this.product,
  }) : assert(product != null);

  final ProductDetails product;
}

class BuyQuestsAccessAsyncAction extends AsyncAction<void> {}
