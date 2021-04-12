import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/new_game/actions/get_quests_action.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/purchases/quests_purchase_page.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/presentation/quests/quests_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_list_widget.dart';
import 'package:cash_flow/widgets/progress/games_loadable_list_view.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class QuestList extends HookWidget {
  const QuestList({
    @required this.selectedItemId,
    @required this.onSelectionChanged,
  });

  final String selectedItemId;
  final void Function(String) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final getQuestsRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.getQuests),
    );

    final user = useCurrentUser();
    final completedGames = useCompletedQuestGames();
    final currentQuestIndex = user.currentQuestIndex ?? 0;
    final quests = useQuestsTemplates(completedGames);

    final dispatch = useDispatcher();

    final mediaQueryData = useAdaptiveMediaQueryData();
    final swiperController = useState(SwiperController());
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    bool isQuestAvailable(int index) {
      return index <= currentQuestIndex ||
          completedGames.any((e) => e.templateId == quests.itemsIds[index]);
    }

    final offsetAnimation = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            }
          });

    useEffect(() {
      swiperController.value.addListener(() {
        final currentIndex = swiperController.value.index;
        final quest = quests.itemsMap[currentIndex].name;
        AnalyticsSender.questsSwipeGame(quest);
      });

      return swiperController.dispose;
    }, []);

    return MediaQuery(
      data: mediaQueryData,
      child: LoadableView(
        isLoading: getQuestsRequestState.isInProgress ||
            getQuestsRequestState.isRefreshing,
        backgroundColor: ColorRes.transparent,
        indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
        child: GamesLoadableListView<Quest>(
          swiperController: swiperController.value,
          viewModel: LoadableListViewModel(
            items: quests,
            itemBuilder: (i) {
              if (i == currentQuestIndex) {
                return AnimatedBuilder(
                  animation: offsetAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(offsetAnimation.value, 0),
                    child: _QuestItemWidget(
                      quest: quests.items[i],
                      index: i,
                      selectedItemId: selectedItemId,
                      onSelectionChanged: onSelectionChanged,
                    ),
                  ),
                );
              }

              return Opacity(
                opacity: isQuestAvailable(i) ? 1.0 : 0.7,
                child: _QuestItemWidget(
                  quest: quests.items[i],
                  index: i,
                  defaultAction: () async {
                    if (i != currentQuestIndex) {
                      await swiperController.value.move(currentQuestIndex);
                    }

                    animationController.forward();
                  },
                  selectedItemId: selectedItemId,
                  onSelectionChanged: onSelectionChanged,
                ),
              );
            },
            loadListRequestState: getQuestsRequestState,
            loadList: () {
              dispatch(GetQuestsAction(userId: userId));
            },
            emptyStateWidget: const EmptyListWidget(),
            errorWidget: CommonErrorWidget(
              () => dispatch(GetQuestsAction(userId: userId)),
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
    @required this.selectedItemId,
    @required this.onSelectionChanged,
    this.defaultAction,
  });

  final Quest quest;
  final int index;
  final VoidCallback defaultAction;
  final String selectedItemId;
  final void Function(String) onSelectionChanged;

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
      selectedQuestId: selectedItemId,
      onSelectionChanged: onSelectionChanged,
    );
  }

  Function(Quest, QuestAction) _getOnQuestSelectedFn() {
    final user = useCurrentUser();
    final startQuest = useQuestStarter();

    final currentQuestIndex = user.currentQuestIndex ?? 0;
    final hasQuestsAccess = user.purchaseProfile?.isQuestsAvailable ?? false;

    final isQuestPurchased =
        index < 1 || hasQuestsAccess || user.boughtQuestsAccess;
    final isQuestOpenedByUser = index <= currentQuestIndex;
    final isQuestAvailable =
        (isQuestPurchased && isQuestOpenedByUser) || DemoMode.isEnabled;

    if (isQuestAvailable) {
      return (quest, action) {
        AnalyticsSender.questSelected(quest.name);

        if (index == 0) {
          AnalyticsSender.questsFirstQuestSelected();
        } else if (index == 1) {
          AnalyticsSender.questsSecondQuestSelected();
        }

        return startQuest(quest.id, action);
      };
    }

    if (isQuestOpenedByUser && !isQuestPurchased) {
      return (level, _) {
        if (index == 1) {
          AnalyticsSender.questsSecondQuestSelected();
        }

        appRouter.goTo(QuestsPurchasePage(quest: level));
      };
    }

    return null;
  }
}
