import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BuyConsumableAction extends BaseAction {
  BuyConsumableAction({
    @required this.product,
  }) : assert(product != null);

  final ProductDetails product;

  @override
  FutureOr<AppState> reduce() async {
    final purchaseService = GetIt.I.get<PurchaseService>();
    await purchaseService.buyConsumable(productDetails: product);

    return null;
  }
}

class BuyNonConsumableAction extends BaseAction {
  BuyNonConsumableAction({
    @required this.product,
  }) : assert(product != null);

  final ProductDetails product;

  @override
  FutureOr<AppState> reduce() async {
    final purchaseService = GetIt.I.get<PurchaseService>();
    await purchaseService.buyNonConsumable(productDetails: product);

    return null;
  }
}
