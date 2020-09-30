import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:built_collection/built_collection.dart';

class OnPurchasesUpdatedAction extends BaseAction {
  OnPurchasesUpdatedAction(this.purchases);

  final List<PurchaseDetails> purchases;

  @override
  FutureOr<AppState> reduce() {
    final boughtQuestsAccess = purchases.any(
      (p) =>
          p.productID == questsAccessProductId &&
          p.status == PurchaseStatus.purchased,
    );

    return state.rebuild((s) {
      s.purchase
        ..updatedPurchases = purchases.toBuiltList().toBuilder()
        ..hasQuestsAccess = s.purchase.hasQuestsAccess || boughtQuestsAccess;
    });
  }
}
