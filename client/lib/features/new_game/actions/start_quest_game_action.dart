import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class StartQuestGameAction extends BaseAction {
  StartQuestGameAction(this.questId, this.action);

  final String questId;
  final QuestAction action;

  @override
  FutureOr<AppState> reduce() async {
    final userId = state.profile.currentUser.id;

    String gameId;

    switch (action) {
      case QuestAction.startNewGame:
        final gameService = GetIt.I.get<GameService>();

        gameId = await performRequest(
          gameService.createQuestGame(gameLevelId: questId, userId: userId),
          NetworkRequest.createQuestGame,
        );
        break;

      case QuestAction.continueGame:
        final currentGameForLevels = state.newGame.currentGameForQuests;
        gameId = currentGameForLevels[questId];
        break;
    }

    if (gameId == null) {
      return null;
    }

    final gameContext = GameContext(gameId: gameId, userId: userId);
    dispatch(StartGameAction(gameContext));

    return state.rebuild((s) {
      s.newGame.newGameId = gameId;
      s.newGame.currentGameForQuests[questId] = gameId;
    });
  }
}
