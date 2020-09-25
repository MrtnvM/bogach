import 'package:cash_flow/app/app_state.dart';
import 'package:async_redux/async_redux.dart';
import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';

class GameViewModel extends BaseModel<AppState> {
  GameViewModel();

  GameViewModel.build({
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

  void Function() loadGameTemplates;
  Future<List<GameLevel>> Function(String) loadGameLevels;
  Future<List<GameLevel>> Function(String) refreshGameLevels;
  Future<String> Function(String templateId) createGame;
  Future<String> Function(String gameLevelId) createGameByLevel;
  void Function(GameLevel, GameLevelAction) startGameByLevel;
  void Function(String gameId) startGame;
  void Function() stopGame;
  Future<void> Function(PlayerAction, String) sendPlayerAction;
  void Function(String) skipPlayerAction;
  void Function() startNewMonth;

  @override
  BaseModel fromStore() {
    final userId = state.login.currentUser?.userId;

    // ignore: avoid_types_on_closure_parameters
    final startGame = (String gameId) {
      final gameContext = GameContext(gameId: gameId, userId: userId);

      dispatch(SetGameContextAction(gameContext));
      dispatch(StartGameAction(gameContext));
    };

    // ignore: avoid_types_on_closure_parameters
    final createGameByLevel = (String gameLevelId) {
      return dispatchFuture(
        CreateNewGameByLevelAsyncAction(gameLevelId: gameLevelId),
      );
    };

    final showCreateGameErrorAlert = showWarningAlert(
      context: appRouter.context, // FIX ME !
      needCancelButton: true,
    );

    return GameViewModel.build(
      loadGameTemplates: () => dispatch(GetGameTemplatesAsyncAction()),
      loadGameLevels: (userId) => dispatchFuture(
        GetGameLevelsAsyncAction(userId: userId),
      ),
      refreshGameLevels: (userId) => dispatchFuture(
        GetGameLevelsAsyncAction(userId: userId, isRefreshing: true),
      ),
      createGame: (templateId) => dispatchFuture(
        CreateNewGameAsyncAction(templateId: templateId),
      ),
      createGameByLevel: createGameByLevel,
      startGameByLevel: (gameLevel, action) {
        final start = (gameId) {
          startGame(gameId);

          appRouter.goToRoot();
          appRouter.goTo(GameBoard());
        };

        if (action == GameLevelAction.continueGame) {
          final currentGameForLevels = state.newGame.currentGameForLevels;
          final gameId = currentGameForLevels[gameLevel.id];

          if (gameId != null) {
            startGame(gameId);
          }

          return;
        }

        createGameByLevel(gameLevel.id)
            .then(start)
            .catchError((error) => showCreateGameErrorAlert(
                  error,
                  () => startGameByLevel(gameLevel, action),
                ));
      },
      startGame: startGame,
      stopGame: () => dispatch(StopActiveGameAction()),
      sendPlayerAction: (action, eventId) {
        return dispatchFuture(
          SendPlayerMoveAsyncAction(playerAction: action, eventId: eventId),
        );
      },
      skipPlayerAction: (eventId) {
        dispatch(SendPlayerMoveAsyncAction(eventId: eventId));
      },
      startNewMonth: () {
        return dispatchFuture(StartNewMonthAsyncAction());
      },
    );
  }
}
