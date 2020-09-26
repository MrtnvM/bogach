import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class CreateNewGameByLevelAction extends BaseAction {
  CreateNewGameByLevelAction({@required this.gameLevelId})
      : assert(gameLevelId != null);

  final String gameLevelId;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final newGameId = await performRequest(
      gameService
          .createNewGameByLevel(
            gameLevelId: gameLevelId,
            userId: state.login.currentUser.userId,
          )
          .first,
      NetworkRequest.createNewGameByLevel,
    );

    return state.rebuild((s) {
      s.newGame.newGameId = newGameId;
      s.newGame.currentGameForLevels[gameLevelId] = newGameId;
    });
  }
}
