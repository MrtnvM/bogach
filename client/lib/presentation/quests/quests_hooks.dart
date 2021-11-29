import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/store_hooks.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/new_game/actions/start_quest_game_action.dart';
import 'package:cash_flow/models/domain/game/quest/quest_ui_model.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
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
      final gameId = store.state.newGame.newGameId!;

      if (isTutorialPassed) {
        appRouter.goTo(GameBoard(gameId: gameId));
      } else {
        appRouter.goTo(TutorialPage(gameId: gameId));
      }
    }).onError((e, st) {
      handleError(context: context, exception: e);
    });
  };
}

StoreList<QuestUiModel>? useQuestsTemplates() {
  return useGlobalState((s) {
    final completedGames =
        s.profile.currentUser?.completedGames.questGames ?? [];
    final questList = s.newGame.quests.items;

    final quests = StoreList(questList.map((quest) {
      final questIndex = questList.indexOf(quest);
      final isFirstQuest = questIndex == 0;

      if (isFirstQuest) {
        return QuestUiModel(quest: quest, isAvailable: true);
      }

      final previousQuest = questList[questIndex - 1];
      final isPreviousQuestWasCompleted =
          completedGames.any((e) => e.templateId == previousQuest.id);

      return QuestUiModel(
        quest: quest,
        isAvailable: isPreviousQuestWasCompleted,
      );
    }).toList());

    quests.updateList(
      quests.items.rebuild(
        (b) => b.sort((a, b) {
          final aIndex = completedGames
              .indexWhere((e) => e.templateId == a.quest.template.id);
          final bIndex = completedGames
              .indexWhere((e) => e.templateId == b.quest.template.id);

          if (aIndex == -1 && bIndex == -1) {
            return 0;
          } else if (aIndex == -1) {
            return -1;
          } else if (bIndex == -1) {
            return 1;
          }

          return aIndex.compareTo(bIndex);
        }),
      ),
    );

    return quests;
  });
}
