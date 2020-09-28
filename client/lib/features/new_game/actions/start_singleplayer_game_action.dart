import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class StartSinglePlayerGameAction extends BaseAction {
  StartSinglePlayerGameAction({@required this.templateId})
      : assert(templateId != null);

  final String templateId;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final createGameRequest = gameService
        .createNewGame(
          templateId: templateId,
          userId: state.profile.currentUser.userId,
        )
        .first;

    final newGameId = await performRequest(
      createGameRequest,
      NetworkRequest.createGame,
    );

    final userId = state.profile.currentUser.id;
    final gameContext = GameContext(gameId: newGameId, userId: userId);
    dispatch(StartGameAction(gameContext));

    return state.rebuild((s) {
      s.newGame.newGameId = newGameId;
    });
  }
}
