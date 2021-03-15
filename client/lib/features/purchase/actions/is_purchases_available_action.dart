import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:get_it/get_it.dart';

class IsPurchasesAvailableAction extends BaseAction {
  IsPurchasesAvailableAction();

  @override
  Future<AppState> reduce() async {
    final purchaseService = GetIt.I.get<PurchaseService>();

    final isAvailable = await purchaseService.isAvailable();

    return state.rebuild((s) {
      s.purchase.isPurchasesAvailable = isAvailable;
    });
  }
}
