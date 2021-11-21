import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/revenue_cat_purchase_service.dart';
import 'package:get_it/get_it.dart';

class RestorePurchasesAction extends BaseAction {
  @override
  Operation get operationKey => Operation.restorePurchases;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  Future<AppState?> reduce() async {
    final purchaseService = GetIt.I.get<RevenueCatPurchaseService>();

    final userId = state.profile.currentUser!.id;
    await purchaseService.login(userId);

    final purchaseProfile = await purchaseService.restorePurchases();

    return state.rebuild((s) {
      s.profile.currentUser = s.profile.currentUser!.copyWith(
        purchaseProfile: purchaseProfile,
      );
    });
  }
}
