import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/core/hooks/store_hooks.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/new_game/actions/start_quest_game_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<void> Function(String questId, QuestAction action) useQuestStarter() {
  final context = useContext();
  final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);
  final store = useStore();

  return (questId, action) {
    if (action == QuestAction.continueGame) {
      AnalyticsSender.questContinue(questId);
    }

    return store
        .dispatchFuture(StartQuestGameAction(questId, action))
        .then((_) {
      final gameId = store.state.newGame.newGameId;

      if (isTutorialPassed) {
        appRouter.goTo(GameBoard(gameId: gameId));
      } else {
        appRouter.goTo(TutorialPage(gameId: gameId));
      }
    }).catchError((e) {
      handleError(context: context, exception: e);
    });
  };
}
