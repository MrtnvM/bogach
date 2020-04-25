import 'package:built_collection/built_collection.dart';
import 'package:cash_flow/models/domain/game_event.dart';
import 'package:cash_flow/models/domain/target_data.dart';
import 'package:cash_flow/models/state/posessions_state/user_possession_state.dart';
import 'package:flutter/material.dart';

class GameData {
  const GameData({
    @required this.possessions,
    @required this.target,
    @required this.events,
  })  : assert(possessions != null),
        assert(events != null),
        assert(target != null);

  final UserPossessionState possessions;
  final TargetData target;
  final BuiltList<GameEvent> events;
}
