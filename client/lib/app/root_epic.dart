import 'package:cash_flow/features/game/game_epic.dart';
import 'package:cash_flow/features/login/login_epic.dart';
import 'package:cash_flow/features/new_game/new_game_epic.dart';
import 'package:cash_flow/features/purchase/purchase_epic.dart';
import 'package:cash_flow/services/new_game_servise.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/purchase_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';

import 'app_state.dart';

Epic<AppState> rootEpic({
  @required UserService userService,
  @required NewGameService newGameService,
  @required GameService gameService,
  @required PurchaseService purchaseService,
}) {
  return combineEpics([
    loginEpic(userService: userService),
    newGameEpic(newGameService: newGameService),
    gameEpic(gameService: gameService),
    purchaseEpic(purchaseService: purchaseService),
  ]);
}
