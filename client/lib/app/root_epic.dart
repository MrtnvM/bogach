import 'package:cash_flow/features/game/game_epic.dart';
import 'package:cash_flow/features/login/login_epic.dart';
import 'package:cash_flow/features/registration/registration_epic.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';

import 'app_state.dart';

Epic<AppState> rootEpic({
  @required UserService userService,
  @required GameService gameService,
}) {
  return combineEpics([
    loginEpic(userService: userService),
    registrationEpic(userService: userService),
    gameEpic(gameService: gameService),
  ]);
}
