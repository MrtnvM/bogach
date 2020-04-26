import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/domain/game_data.dart';
import 'package:cash_flow/models/domain/player_action.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class StartGameAction extends Action {
  StartGameAction(this.gameId);

  final String gameId;
}

class StopActiveGameAction extends Action {
  StopActiveGameAction();
}

class OnGameStateChangedAction extends Action {
  OnGameStateChangedAction(this.data);

  final GameData data;
}

class OnGameErrorAction extends Action {
  OnGameErrorAction(this.error);

  final dynamic error;
}

class SetGameContextAction extends Action {
  SetGameContextAction(this.context);

  final GameContext context;
}

class SendGameEventPlayerActionAsyncAction extends AsyncAction<void> {
  SendGameEventPlayerActionAsyncAction(this.action, this.eventId);

  final PlayerAction action;
  final String eventId;
}

class GoToNewMonthAction extends Action {}
