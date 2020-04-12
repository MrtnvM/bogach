library game_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/state/game/game_event.dart';
import 'package:cash_flow/models/state/posessions_state/user_possession_state.dart';
import 'package:cash_flow/models/state/target_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'game_state.g.dart';

abstract class GameState implements Built<GameState, GameStateBuilder> {
  factory GameState([void Function(GameStateBuilder b) updates]) = _$GameState;

  GameState._();

  RequestState get getRequestState;

  @nullable
  UserPossessionState get possessions;

  @nullable
  TargetState get target;

  BuiltList<GameEvent> get events;

  static GameState initial() => GameState((b) => b
    ..getRequestState = RequestState.idle
    ..events = ListBuilder());
}
