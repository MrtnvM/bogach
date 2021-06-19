import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/new_game/actions/get_quests_action.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/models/domain/game/quest/quest_ui_model.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/purchases/quests_purchase_page.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/presentation/quests/quests_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_list_widget.dart';
import 'package:cash_flow/widgets/progress/games_loadable_list_view.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class QuestList extends HookWidget {
  const QuestList({
    required this.selectedItemId,
    required this.onSelectionChanged,
  });

  final String? selectedItemId;
  final void Function(String?) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final getQuestsRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.getQuests),
    )!;
    final quests = useQuestsTemplates()!;

    final dispatch = useDispatcher();

    final mediaQueryData = useAdaptiveMediaQueryData();
    final swiperController = useState(SwiperController());
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

    useEffect(() => swiperController.dispose, []);

    return MediaQuery(
      data: mediaQueryData,
      child: LoadableView(
        isLoading: getQuestsRequestState.isInProgress ||
            getQuestsRequestState.isRefreshing,
        backgroundColor: ColorRes.transparent,
        indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
        child: GamesLoadableListView<QuestUiModel>(
          swiperController: swiperController.value,
          viewModel: LoadableListViewModel(
            items: quests,
            itemBuilder: (i) {
              if (i == 0) {
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
                opacity: quests.items[i].isAvailable ? 1.0 : 0.7,
                child: _QuestItemWidget(
                  quest: quests.items[i],
                  index: i,
                  defaultAction: () async {
                    if (!quests.items[i].isAvailable) {
                      var nearestAvailableQuest = -1;

                      for (var j = i - 1; j >= 0; j--) {
                        if (quests.items[j].isAvailable) {
                          nearestAvailableQuest = j;
                          break;
                        }
                      }

                      await swiperController.value.move(nearestAvailableQuest);
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
              dispatch(GetQuestsAction(userId: userId!));
            },
            emptyStateWidget: const EmptyListWidget(),
            errorWidget: CommonErrorWidget(
              () => dispatch(GetQuestsAction(userId: userId!)),
            ),
            itemSeparator: (i) => const SizedBox(),
          ),
        ),
      ),
    );
  }
}

class _QuestItemWidget extends HookWidget {
  const _QuestItemWidget({
    required this.quest,
    required this.index,
    required this.selectedItemId,
    required this.onSelectionChanged,
    this.defaultAction,
  });

  final QuestUiModel quest;
  final int index;
  final VoidCallback? defaultAction;
  final String? selectedItemId;
  final void Function(String?) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final onQuestSelected = _getOnQuestSelectedFn(quest);
    final user = useCurrentUser()!;
    final lastQuestGameInfo = user.lastGames.questGames.firstWhereOrNull(
      (g) => g.templateId == quest.id,
    );

    return QuestItemWidget(
      quest: quest.quest,
      currentGameId: lastQuestGameInfo?.gameId,
      isLocked: onQuestSelected == null,
      onQuestSelected: onQuestSelected ?? ((l, a) => defaultAction?.call()),
      selectedQuestId: selectedItemId,
      onSelectionChanged: onSelectionChanged,
    );
  }

  Function(Quest?, QuestAction)? _getOnQuestSelectedFn(QuestUiModel quest) {
    final user = useCurrentUser()!;
    final startQuest = useQuestStarter();
    final quests = useGlobalState((s) => s.newGame.quests)!;

    final hasQuestsAccess = user.purchaseProfile?.isQuestsAvailable ?? false;
    final isFirstQuest = quests.itemsIds.first == quest.id;

    final isQuestPurchased =
        isFirstQuest || hasQuestsAccess || user.boughtQuestsAccess!;
    final isQuestOpenedByUser = quest.isAvailable;
    final isQuestAvailable =
        (isQuestPurchased && isQuestOpenedByUser) || DemoMode.isEnabled;

    if (isQuestAvailable) {
      return (quest, action) {
        AnalyticsSender.questSelected(quest!.name);

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
