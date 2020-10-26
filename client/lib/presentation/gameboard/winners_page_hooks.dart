import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/new_game/actions/start_quest_game_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

VoidCallback useGameRestarter() {
  final context = useContext();
  final dispatch = useDispatcher();
  final currentQuest = useCurrentGame((g) => g.config.level);

  void Function() startAgain;
  startAgain = () {
    if (currentQuest == null) {
      return;
    }

    final action = StartQuestGameAction(
      currentQuest,
      QuestAction.startNewGame,
    );

    dispatch(action).then((_) {
      appRouter.goTo(const GameBoard());
    }).catchError(
      (error) => handleError(
        context: context,
        exception: error,
        onRetry: startAgain,
      ),
    );
  };

  return startAgain;
}
