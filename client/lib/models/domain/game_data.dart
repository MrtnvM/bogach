import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/models/domain/game_event.dart';
import 'package:cash_flow/models/domain/target_data.dart';
import 'package:cash_flow/models/state/game/account/account.dart';
import 'package:cash_flow/models/state/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/state/game/posessions/user_possession_state.dart';
import 'package:flutter/material.dart';

class GameData {
  const GameData({
    @required this.possessions,
    @required this.target,
    @required this.account,
    @required this.gameState,
    @required this.events,
  })  : assert(possessions != null),
        assert(events != null),
        assert(target != null),
        assert(account != null);

  final UserPossessionState possessions;
  final TargetData target;
  final Account account;
  final CurrentGameState gameState;
  final BuiltList<GameEvent> events;
}
