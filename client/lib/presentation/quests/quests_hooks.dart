import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/new_game/actions/start_quest_game_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<void> Function(String questId, QuestAction action) useQuestStarter() {
  final context = useContext();
  final dispatch = useDispatcher();
  final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);

  return (questId, action) {
    if (action == QuestAction.continueGame) {
      AnalyticsSender.questContinue(questId);
    }

    return dispatch(StartQuestGameAction(questId, action)).then((_) {
      if (isTutorialPassed) {
        final appState = StoreProvider.state<AppState>(context);
        final gameId = appState.newGame.newGameId;
        appRouter.goTo(GameBoard(gameId: gameId));
      } else {
        appRouter.goTo(const TutorialPage());
      }
    }).catchError((e) => handleError(context: context, exception: e));
  };
}
