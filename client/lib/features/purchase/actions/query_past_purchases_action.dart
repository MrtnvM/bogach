import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:built_collection/built_collection.dart';

class QueryPastPurchasesAction extends BaseAction {
  @override
  Operation get operationKey => Operation.queryPastPurchases;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  FutureOr<AppState> reduce() async {
    final purchaseService = GetIt.I.get<PurchaseService>();

    final userId = state.profile.currentUser?.id;
    await purchaseService.queryPastPurchases(userId);

    return null;
  }
}

class OnPastPurchasesRestoredAction extends BaseAction {
  OnPastPurchasesRestoredAction(this.pastPurchases);

  final List<PurchaseDetails> pastPurchases;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  FutureOr<AppState> reduce() {
    final purchases = pastPurchases;
    final boughtQuestsAccess = purchases.any(
      (p) =>
          p.productID == questsAccessProductId &&
          p.status == PurchaseStatus.purchased,
    );

    return state.rebuild((s) {
      s.purchase
        ..pastPurchases = purchases.toBuiltList().toBuilder()
        ..hasQuestsAccess = s.purchase.hasQuestsAccess || boughtQuestsAccess;
    });
  }
}
