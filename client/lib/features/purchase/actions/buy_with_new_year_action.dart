import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/services/revenue_cat_purchase_service.dart';
import 'package:get_it/get_it.dart';

class BuyWithDiscountActionAction extends BaseAction {
  @override
  Operation get operationKey => Operation.buyWithDiscountAction;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  Future<AppState?> reduce() async {
    final purchaseService = GetIt.I.get<RevenueCatPurchaseService>();
    final productId = newYear2022ActionProductId;
    final purchaseProfile = await purchaseService.purchase(productId);

    return state.rebuild((s) {
      s.profile.currentUser = s.profile.currentUser!.copyWith(
        purchaseProfile: purchaseProfile,
      );
    });
  }
}
