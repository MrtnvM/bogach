import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class StartGameByLevelAction extends BaseAction {
  StartGameByLevelAction(this.gameLevel, this.action);

  final GameLevel gameLevel;
  final GameLevelAction action;

  @override
  FutureOr<AppState> reduce() async {
    final userId = state.login.currentUser.id;

    if (action == GameLevelAction.continueGame) {
      final currentGameForLevels = state.newGame.currentGameForLevels;
      final gameId = currentGameForLevels[gameLevel.id];
      dispatch(StartGameAction(GameContext(gameId: gameId, userId: userId)));
      return null;
    }

    final gameService = GetIt.I.get<GameService>();

    await performRequest(
      gameService
          .createNewGameByLevel(
            gameLevelId: gameLevel.id,
            userId: state.login.currentUser.userId,
          )
          .first
          .then(
            (newGameId) => dispatch(
              StartGameAction(GameContext(gameId: newGameId, userId: userId)),
            ),
          ),
      NetworkRequest.createNewGameByLevel,
    );

    return null;
  }
}
