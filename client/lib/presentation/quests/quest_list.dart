import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/new_game/actions/get_quests_action.dart';
import 'package:cash_flow/features/new_game/actions/start_quest_game_action.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/purchases/quests_access_page.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final getQuestsRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.getQuests),
    );
    final createQuestGameRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.createQuestGame),
    );

    final user = useCurrentUser();
    final currentQuestIndex = user.currentQuestIndex ?? 0;
    final quests = useGlobalState((s) => s.newGame.quests);

    final dispatch = useDispatcher();

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final textScaleFactor = screenWidth <= 350 ? 0.8 : 1.0;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final offsetAnimation = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            }
          });

    return MediaQuery(
      data: mediaQuery.copyWith(textScaleFactor: textScaleFactor),
      child: LoadableView(
        isLoading: getQuestsRequestState.isInProgress ||
            createQuestGameRequestState.isInProgress,
        backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
        child: RefreshIndicator(
          color: ColorRes.mainGreen,
          onRefresh: () => Future.wait([
            dispatch(GetQuestsAction(userId: userId, isRefreshing: true)),
          ]),
          child: LoadableListView<Quest>(
            viewModel: LoadableListViewModel(
              items: quests,
              itemBuilder: (i) {
                if (i == currentQuestIndex) {
                  return AnimatedBuilder(
                    animation: offsetAnimation,
                    builder: (context, child) => Padding(
                      padding: EdgeInsets.only(
                        left: offsetAnimation.value + 10,
                        right: 10 - offsetAnimation.value,
                      ),
                      child: _QuestItemWidget(
                        quest: quests.items[i],
                        index: i,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _QuestItemWidget(
                    quest: quests.items[i],
                    index: i,
                    defaultAction: animationController.forward,
                  ),
                );
              },
              loadListRequestState: getQuestsRequestState,
              loadList: () {
                dispatch(GetQuestsAction(userId: userId));
              },
              padding: const EdgeInsets.all(16),
              emptyStateWidget: EmptyWidget(),
              errorWidget: CommonErrorWidget(
                () => dispatch(GetQuestsAction(userId: userId)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestItemWidget extends HookWidget {
  const _QuestItemWidget({
    @required this.quest,
    @required this.index,
    this.defaultAction,
  });

  final Quest quest;
  final int index;
  final VoidCallback defaultAction;

  @override
  Widget build(BuildContext context) {
    final onQuestSelected = _getOnQuestSelectedFn();
    final user = useCurrentUser();
    final lastQuestGameInfo = user.lastGames.questGames.firstWhere(
      (g) => g.templateId == quest.id,
      orElse: () => null,
    );

    return QuestItemWidget(
      quest: quest,
      currentGameId: lastQuestGameInfo?.gameId,
      isLocked: onQuestSelected == null,
      onQuestSelected: onQuestSelected ?? (l, a) => defaultAction(),
    );
  }

  Function(Quest, QuestAction) _getOnQuestSelectedFn() {
    final context = useContext();
    final user = useCurrentUser();

    final currentQuestIndex = user.currentQuestIndex ?? 0;
    final hasQuestsAccess = user.purchaseProfile?.isQuestsAvailable ?? false;

    final isQuestPurchased =
        index < 1 || hasQuestsAccess || user.boughtQuestsAccess;
    final isQuestOpenedByUser = index <= currentQuestIndex;
    final isQuestAvailable =
        (isQuestPurchased && isQuestOpenedByUser) || DemoMode.isEnabled;

    final dispatch = useDispatcher();
    final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);

    if (isQuestAvailable) {
      return (quest, action) {
        AnalyticsSender.questSelected();

        if (index == 0) {
          AnalyticsSender.questsFirstQuestSelected();
        } else if (index == 1) {
          AnalyticsSender.questsSecondQuestSelected();
        }

        if (action == QuestAction.startNewGame) {
          AnalyticsSender.questStart(quest.id);
        } else if (action == QuestAction.continueGame) {
          AnalyticsSender.questContinue(quest.id);
        }

        return dispatch(StartQuestGameAction(quest.id, action))
            .then((_) => isTutorialPassed
                ? appRouter.goTo(const GameBoard())
                : appRouter.goTo(const TutorialPage()))
            .catchError((e) => handleError(context: context, exception: e));
      };
    }

    if (isQuestOpenedByUser && !isQuestPurchased) {
      return (level, _) {
        if (index == 1) {
          AnalyticsSender.questsSecondQuestSelected();
        }

        appRouter.goTo(QuestsAccessPage(quest: level));
      };
    }

    return null;
  }
}
