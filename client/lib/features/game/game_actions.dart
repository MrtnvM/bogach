import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/player_action/player_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class StartGameAction extends Action {
  StartGameAction(this.gameContext) : assert(gameContext != null);

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
  SendPlayerMoveAsyncAction({
    @required this.eventId,
    this.playerAction,
  });

  final PlayerAction playerAction;
  final String eventId;
}

class StartNewMonthAsyncAction extends AsyncAction {}

class SetGameParticipnatsProfiles extends Action {
  SetGameParticipnatsProfiles(this.userProfiles) : assert(userProfiles != null);

  final List<UserProfile> userProfiles;
}
