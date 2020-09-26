import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/features/new_game/actions/get_game_levels_action.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/presentation/purchases/quests_access_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart' hide StoreProvider;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:async_redux/async_redux.dart';

class GameLevelList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final gameLevelsRequestState = useGlobalState(
      (s) => s.network.getRequestState(NetworkRequest.getGameLevels),
    );
    final createQuestGameRequestState = useGlobalState(
      (s) => s.network.getRequestState(NetworkRequest.createNewGameByLevel),
    );

    final gameLevels = useGlobalState((s) => s.newGame.gameLevels);

    final dispatch = useDispatcher();

    return LoadableView(
      isLoading: gameLevelsRequestState.isInProgress ||
          createQuestGameRequestState.isInProgress,
      backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
      child: RefreshIndicator(
        color: ColorRes.mainGreen,
        onRefresh: () => Future.wait([
          dispatch(GetGameLevelsAction(userId: userId, isRefreshing: true)),
          dispatch(LoadCurrentUserProfileAsyncAction())
        ]),
        child: LoadableListView<GameLevel>(
          viewModel: LoadableListViewModel(
            items: gameLevels,
            itemBuilder: (i) => _GameLevelItemWidget(
              gameLevel: gameLevels.items[i],
              index: i,
            ),
            loadListRequestState: gameLevelsRequestState,
            loadList: () {
              dispatch(GetGameLevelsAction(userId: userId));
              dispatch(LoadCurrentUserProfileAsyncAction());
            },
            padding: const EdgeInsets.all(16),
            emptyStateWidget: EmptyWidget(),
            errorWidget: CommonErrorWidget(
              () => dispatch(GetGameLevelsAction(userId: userId)),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameLevelItemWidget extends HookWidget {
  const _GameLevelItemWidget({
    @required this.gameLevel,
    @required this.index,
  });

  final GameLevel gameLevel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final currentGameForLevels = useGlobalState(
      (s) => s.newGame.currentGameForLevels,
    );

    final onLevelSelected = _getOnLevelSelectedFn();

    return GameLevelItemWidget(
      gameLevel: gameLevel,
      currentGameId: currentGameForLevels[gameLevel.id],
      onLevelSelected: onLevelSelected,
    );
  }

  Function(GameLevel, GameLevelAction) _getOnLevelSelectedFn() {
    final user = useCurrentUser();
    final currentQuestIndex = user.currentQuestIndex ?? 0;

    final hasQuestsAccess = useGlobalState((s) => s.purchase.hasQuestsAccess);
    final isQuestPurchased =
        index < 1 || hasQuestsAccess || user.boughtQuestsAccess;
    final isQuestOpenedByUser = index <= currentQuestIndex;
    final isQuestAvailable =
        (isQuestPurchased && isQuestOpenedByUser) || DemoMode.isEnabled;

    final dispatch = useDispatcher();

    if (isQuestAvailable) {
      return (gameLevel, action) => dispatch(StartGameByLevelAction());
    }

    if (isQuestOpenedByUser && !isQuestPurchased) {
      return (level, _) => appRouter.goTo(QuestsAccessPage(gameLevel: level));
    }

    return null;
  }
}
