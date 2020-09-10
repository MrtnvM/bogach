import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

T useCurrentGame<T>(T Function(Game) convertor) {
  return useGlobalState((s) => convertor(s.game.currentGame));
}

_GameActions useGameActions() {
  final userId = useUserId();
  final actionRunner = useActionRunner();
  final currentGameForLevels = useGlobalState(
    (s) => s.newGame.currentGameForLevels,
  );

  final showCreateGameErrorAlert = useWarningAlert(
    needCancelButton: true,
  );

  _GameActions gameActions;

  gameActions = useMemoized(() {
    return _GameActions(
      loadGameTemplates: () {
        actionRunner.runAction(GetGameTemplatesAsyncAction());
      },
      loadGameLevels: (userId) {
        return actionRunner.runAsyncAction(GetGameLevelsAsyncAction(
          userId: userId,
        ));
      },
      refreshGameLevels: (userId) {
        return actionRunner.runAsyncAction(GetGameLevelsAsyncAction(
          userId: userId,
          isRefreshing: true,
        ));
      },
      createGame: (templateId) {
        return actionRunner.runAsyncAction(
          CreateNewGameAsyncAction(templateId: templateId),
        );
      },
      createGameByLevel: (gameLevelId) {
        return actionRunner.runAsyncAction(
          CreateNewGameByLevelAsyncAction(gameLevelId: gameLevelId),
        );
      },
      startGameByLevel: (gameLevel, action) {
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
                  () => gameActions.startGameByLevel(gameLevel, action),
                ));
      },
      startGame: (gameId) {
        final gameContext = GameContext(gameId: gameId, userId: userId);

        actionRunner.runAction(SetGameContextAction(gameContext));
        actionRunner.runAction(StartGameAction(gameContext));
      },
      stopGame: () {
        actionRunner.runAction(StopActiveGameAction());
      },
      sendPlayerAction: (action, eventId) {
        return actionRunner.runAsyncAction(
          SendPlayerMoveAsyncAction(playerAction: action, eventId: eventId),
        );
      },
      skipPlayerAction: (eventId) {
        actionRunner.runAction(SendPlayerMoveAsyncAction(eventId: eventId));
      },
      startNewMonth: () {
        return actionRunner.runAsyncAction(StartNewMonthAsyncAction());
      },
    );
  }, [userId]);

  return gameActions;
}

class _GameActions {
  const _GameActions({
    this.loadGameTemplates,
    this.loadGameLevels,
    this.refreshGameLevels,
    this.createGame,
    this.createGameByLevel,
    this.startGameByLevel,
    this.startGame,
    this.stopGame,
    this.sendPlayerAction,
    this.skipPlayerAction,
    this.startNewMonth,
  });

  final void Function() loadGameTemplates;
  final Future<List<GameLevel>> Function(String) loadGameLevels;
  final Future<List<GameLevel>> Function(String) refreshGameLevels;
  final Future<String> Function(String templateId) createGame;
  final Future<String> Function(String gameLevelId) createGameByLevel;
  final void Function(GameLevel, GameLevelAction) startGameByLevel;
  final void Function(String gameId) startGame;
  final void Function() stopGame;
  final Future<void> Function(PlayerAction, String) sendPlayerAction;
  final void Function(String) skipPlayerAction;
  final void Function() startNewMonth;
}
