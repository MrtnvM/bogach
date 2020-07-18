import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/new_game/new_game_actions.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

T useCurrentGame<T>(T Function(Game) convertor) {
  return useGlobalState((s) => convertor(s.game.currentGame));
}

_GameActions useGameActions() {
  final userId = useUserId();
  final actionRunner = useActionRunner();

  final gameActions = useMemoized(() {
    return _GameActions(
      loadGameTemplates: () {
        actionRunner.runAction(GetGameTemplatesAsyncAction());
      },
      loadGameLevels: () {
        return actionRunner.runAsyncAction(GetGameLevelsAsyncAction());
      },
      createGame: (templateId) {
        return actionRunner.runAsyncAction(
          CreateNewGameAsyncAction(templateId: templateId),
        );
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
    this.createGame,
    this.startGame,
    this.stopGame,
    this.sendPlayerAction,
    this.skipPlayerAction,
    this.startNewMonth,
  });

  final void Function() loadGameTemplates;
  final void Function() loadGameLevels;
  final Future<String> Function(String templateId) createGame;
  final void Function(String gameId) startGame;
  final void Function() stopGame;
  final Future<void> Function(PlayerAction, String) sendPlayerAction;
  final void Function(String) skipPlayerAction;
  final void Function() startNewMonth;
}
