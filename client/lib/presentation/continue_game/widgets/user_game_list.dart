import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/continue_game/widgets/game_item.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';

class UserGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final userGames = useGlobalState((s) => s.newGame.userGames);
    final requestState = useGlobalState(
      (s) => s.newGame.getUserGamesRequestState,
    );

    final gameActions = useGameActions();
    final goToGame = (gameId) {
      gameActions.startGame(gameId);

      appRouter.goToRoot();
      appRouter.goTo(GameBoard());
    };

    final actionRunner = useActionRunner();
    final loadUserGames = () {
      actionRunner.runAction(GetUserGamesAsyncAction(userId: userId));
    };

    return Loadable(
      isLoading: requestState.isInProgress,
      backgroundColor: ColorRes.mainGreen,
      child: LoadableList<Game>(
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
          errorWidget: ErrorWidget(loadUserGames),
        ),
      ),
    );
  }
}
