import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class GameLevelList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final gameLevelsRequestState = useGlobalState(
      (s) => s.newGame.getGameLevelsRequestState,
    );

    final gameLevels = useGlobalState((s) => s.newGame.gameLevels);
    final gameActions = useGameActions();

    final showCreateGameErrorAlert = useWarningAlert(
      needCancelButton: true,
    );

    void Function(GameLevel) createNewGameByLevel;
    createNewGameByLevel = (gameLevel) {
      gameActions.createGameByLevel(gameLevel.id).then((createdGameId) {
        gameActions.startGame(createdGameId);

        appRouter.goToRoot();
        appRouter.goTo(GameBoard());
      }).catchError(
        (error) => showCreateGameErrorAlert(
          error,
          () => createNewGameByLevel(gameLevel),
        ),
      );
    };

    return Loadable(
      isLoading: gameLevelsRequestState.isInProgress,
      backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
      child: LoadableList<GameLevel>(
        viewModel: LoadableListViewModel(
          items: gameLevels,
          itemBuilder: (i) => GameLevelItem(
            gameLevel: gameLevels.items[i],
            onLevelSelected: createNewGameByLevel,
          ),
          loadListRequestState: gameLevelsRequestState,
          loadList: gameActions.loadGameLevels,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
