import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class StartListeningPurchasesAction extends Action {
  StartListeningPurchasesAction();
}

class ListeningPurchasesSuccessAction extends Action {
  ListeningPurchasesSuccessAction(this.purchases);

  final BuiltList<PurchaseDetails> purchases;
}

class ListeningPurchasesErrorAction extends Action {
  ListeningPurchasesErrorAction(this.error);

  final dynamic error;
}

class StopListeningPurchasesAction extends Action {
  StopListeningPurchasesAction();
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
