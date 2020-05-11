import 'package:cash_flow/features/game/game_epic.dart';
import 'package:cash_flow/features/login/login_epic.dart';
import 'package:cash_flow/features/new_game/new_game_epic.dart';
import 'package:cash_flow/features/purchase/purchase_epic.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';

import 'app_state.dart';

Epic<AppState> rootEpic({
  @required UserService userService,
  @required GameService gameService,
  @required PurchaseService purchaseService,
}) {
  return combineEpics([
    loginEpic(userService: userService),
    newGameEpic(gameService: gameService),
    gameEpic(gameService: gameService),
    purchaseEpic(purchaseService: purchaseService),
  ]);
}
