import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/common/common_error_widget.dart';
import 'package:cash_flow/widgets/common/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';

class GameLevelList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final gameLevelsRequestState = useGlobalState(
      (s) => s.newGame.getGameLevelsRequestState,
    );
    final createQuestGameRequestState = useGlobalState(
      (s) => s.newGame.createNewGameByLevelRequestState,
    );

    final gameLevels = useGlobalState((s) => s.newGame.gameLevels);
    final currentGameForLevels = useGlobalState(
      (s) => s.newGame.currentGameForLevels,
    );

    final gameActions = useGameActions();

    final showCreateGameErrorAlert = useWarningAlert(
      needCancelButton: true,
    );

    void Function(GameLevel, GameLevelAction) startGameByLevel;
    startGameByLevel = (gameLevel, action) {
      final startGame = (gameId) {
        gameActions.startGame(gameId);

        appRouter.goToRoot();
        appRouter.goTo(GameBoard());
      };

      if (action == GameLevelAction.continueGame) {
        final gameId = currentGameForLevels[gameLevel.id];

        if (gameId != null) {
          startGame(gameId);
        }

        return;
      }

      gameActions
          .createGameByLevel(gameLevel.id)
          .then(startGame)
          .catchError((error) => showCreateGameErrorAlert(
                error,
                () => startGameByLevel(gameLevel, action),
              ));
    };

    return Loadable(
      isLoading: gameLevelsRequestState.isInProgress ||
          createQuestGameRequestState.isInProgress,
      backgroundColor: ColorRes.mainGreen.withOpacity(0.8),
      child: LoadableList<GameLevel>(
        viewModel: LoadableListViewModel(
          items: gameLevels,
          itemBuilder: (i) => GameLevelItemWidget(
            gameLevel: gameLevels.items[i],
            onLevelSelected: startGameByLevel,
          ),
          loadListRequestState: gameLevelsRequestState,
          loadList: () => gameActions.loadGameLevels(userId),
          padding: const EdgeInsets.all(16),
          emptyStateWidget: EmptyWidget(),
          errorWidget: CommonErrorWidget(
            () => gameActions.loadGameLevels(userId),
          ),
        ),
      ),
    );
  }
}
