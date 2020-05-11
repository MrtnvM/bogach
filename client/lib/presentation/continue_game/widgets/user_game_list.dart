import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatch_hook.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/continue_game/widgets/game_item.dart';
import 'package:cash_flow/presentation/gameboard/game_board.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class UserGameList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final userGames = useGlobalState((s) => s.newGameState.userGames);
    final requestState = useGlobalState(
      (s) => s.newGameState.getUserGamesRequestState,
    );

    final goToGame = (gameId) {
      final gameContext = GameContext(gameId: gameId, userId: userId);

      appRouter.goToRoot();
      appRouter.goTo(GameBoard(gameContext: gameContext));
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
        ),
      ),
    );
  }
}
