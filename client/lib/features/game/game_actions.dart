import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/models/errors/game_error.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class StartGameAction extends Action {
  StartGameAction(this.gameContext);

  final GameContext gameContext;

  @override
  String toString() {
    return '${super.toString()} $gameContext';
  }
}

class StopActiveGameAction extends Action {
  StopActiveGameAction();
}

class OnGameStateChangedAction extends Action {
  OnGameStateChangedAction(this.game);

  final Game game;
}

class OnGameErrorAction extends Action {
  OnGameErrorAction(this.error);

  final dynamic error;

  @override
  String toString() {
    return '${super.toString()}' '\n$error';
  }
}

class SetGameContextAction extends Action {
  SetGameContextAction(this.gameContext);

  final GameContext gameContext;
}

class SendPlayerMoveAsyncAction extends AsyncAction<void> {
  SendPlayerMoveAsyncAction(this.playerAction, this.eventId);

  final PlayerAction playerAction;
  final String eventId;
}

class SkipPlayerMoveAction extends Action {}

class GoToNewMonthAction extends Action {}
