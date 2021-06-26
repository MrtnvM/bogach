import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/new_game/actions/start_quest_game_action.dart';
import 'package:cash_flow/features/new_game/actions/start_singleplayer_game_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

VoidCallback useGameRestarter() {
  final context = useContext();
  final dispatch = useDispatcher();
  final gameTemplateId = useCurrentGame((g) => g?.config.gameTemplateId);
  final currentQuest = useCurrentGame((g) => g?.config.level);

  void Function()? startAgain;
  startAgain = () {
    BaseAction? startGameAction;

    if (gameTemplateId != null) {
      startGameAction = StartSinglePlayerGameAction(
        templateId: gameTemplateId,
      );
    } else if (currentQuest != null) {
      startGameAction = StartQuestGameAction(
        currentQuest,
        QuestAction.startNewGame,
      );
    }

    if (startGameAction == null) {
      return;
    }

    dispatch(startGameAction).then((_) {
      final appState = StoreProvider.state<AppState>(context);
      final newGameId = appState?.newGame.newGameId;

      if (newGameId == null) {
        throw Exception('No newGameId on starting game');
      }

      appRouter.goToRoot();
      appRouter.goTo(GameBoard(gameId: newGameId));
    }).onError(
      (error, st) {
        handleError(
          context: context,
          exception: error,
          onRetry: startAgain,
        );
      },
    );
  };

  return startAgain;
}
