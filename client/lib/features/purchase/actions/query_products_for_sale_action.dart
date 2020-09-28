import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class QueryProductsForSaleAction extends BaseAction {
  QueryProductsForSaleAction({@required this.ids})
      : assert(ids?.isNotEmpty == true);

  final Set<String> ids;

  @override
  NetworkRequest get operationKey => NetworkRequest.queryProductDetails;

  @override
  FutureOr<AppState> reduce() async {
    final purchaseService = GetIt.I.get<PurchaseService>();

    final productsForSale = await purchaseService.queryProductDetails(ids: ids);

    return state.rebuild((s) {
      s.purchase.productsForSale = productsForSale.toBuilder();
    });
  }
}
