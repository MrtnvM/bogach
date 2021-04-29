import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:built_collection/built_collection.dart';

class QueryProductsForSaleAction extends BaseAction {
  QueryProductsForSaleAction({required this.ids})
      : assert(ids.isNotEmpty);

  final Set<String> ids;

  @override
  Operation get operationKey => Operation.queryProductDetails;

  @override
  Future<AppState> reduce() async {
    final purchaseService = GetIt.I.get<PurchaseService>();

    final productsForSale = await purchaseService.queryProductDetails(ids: ids);

    return state.rebuild((s) {
      s.purchase.productsForSale = productsForSale.toBuiltList().toBuilder();
    });
  }
}
