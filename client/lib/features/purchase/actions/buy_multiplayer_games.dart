import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:get_it/get_it.dart';

class BuyMultiplayerGames extends BaseAction {
  BuyMultiplayerGames(this.productId);

  final String productId;

  @override
  Operation get operationKey => Operation.buyMultiplayerGames;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  FutureOr<AppState> reduce() async {
    final purchaseService = GetIt.I.get<PurchaseService>();
    final userId = state.profile.currentUser.id;
    final boughtGamesCount = await purchaseService.buyMultiplayerGames(
      userId: userId,
      productId: productId,
    );

    return state.rebuild((b) => b.profile.currentUser = b.profile.currentUser
        .copyWith(
            multiplayerGamesCount: b.profile.currentUser.multiplayerGamesCount +
                boughtGamesCount));
  }
}
