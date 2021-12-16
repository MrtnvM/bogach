import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/services/revenue_cat_purchase_service.dart';
import 'package:fimber/fimber.dart';
import 'package:get_it/get_it.dart';

class BuyMultiplayerGames extends BaseAction {
  BuyMultiplayerGames(this.purchase);

  final MultiplayerGamePurchases purchase;

  @override
  Operation get operationKey => Operation.buyMultiplayerGames;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  Future<AppState?> reduce() async {
    final purchaseService = GetIt.I.get<RevenueCatPurchaseService>();
    final purchaseProfile = await purchaseService.purchase(purchase.productId);

    Fimber.i('New purchase profile:\n$purchaseProfile');

    return state.rebuild((s) {
      s.profile.currentUser = s.profile.currentUser!.copyWith(
        purchaseProfile: purchaseProfile,
      );
    });
  }
}
