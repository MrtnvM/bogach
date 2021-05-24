import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class StartQuestGameAction extends BaseAction {
  StartQuestGameAction(this.questId, this.action);

  final String questId;
  final QuestAction action;

  @override
  Operation get operationKey => Operation.createQuestGame;

  @override
  Future<AppState> reduce() async {
    final currentUser = state.profile.currentUser!;
    final userId = currentUser.id;

    final getGameId = () async {
      switch (action) {
        case QuestAction.startNewGame:
          final gameService = GetIt.I.get<GameService>();

          return await gameService.createQuestGame(
            gameLevelId: questId,
            userId: userId,
          );

        case QuestAction.continueGame:
          final questGames = currentUser.lastGames.questGames;
          final index = questGames.indexWhere((g) => g.templateId == questId);
          return index < 0 ? null : questGames[index].gameId;
      }
    };

    final gameId = await getGameId();

    return state.rebuild((s) {
      s.newGame.newGameId = gameId;
    });
  }
}
