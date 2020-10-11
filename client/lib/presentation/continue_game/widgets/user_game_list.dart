import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/new_game/actions/get_user_games_action.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/continue_game/widgets/game_item.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class UserGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final userGames = useGlobalState((s) => s.newGame.userGames);
    final requestState = useGlobalState(
      (s) => s.getOperationState(Operation.getUserGames),
    );
    final createGameRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.createGame),
    );

    final dispatch = useDispatcher();

    final goToGame = (gameId) {
      final gameContext = GameContext(gameId: gameId, userId: userId);
      dispatch(StartGameAction(gameContext));

      appRouter.goToRoot();
      appRouter.goTo(const GameBoard());
    };

    final loadUserGames = () {
      dispatch(GetUserGamesAction(userId: userId));
    };

    return LoadableView(
      isLoading:
          requestState.isInProgress || createGameRequestState.isInProgress,
      backgroundColor: ColorRes.mainGreen,
      child: LoadableListView<Game>(
        viewModel: LoadableListViewModel(
          items: userGames,
          itemBuilder: (i) => GameItem(
            game: userGames.items[i],
            onGameSelected: (game) => goToGame(game.id),
          ),
          loadListRequestState: requestState,
          loadList: loadUserGames,
          padding: const EdgeInsets.all(16),
          emptyStateWidget: EmptyWidget(),
          errorWidget: CommonErrorWidget(loadUserGames),
        ),
      ),
    );
  }
}
