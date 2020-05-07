library game_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/active_game_state.dart';
import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/domain/game_event.dart';
import 'package:cash_flow/models/state/game/account/account.dart';
import 'package:cash_flow/models/state/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/state/game/posessions/user_possession_state.dart';
import 'package:cash_flow/models/state/game/target/target_state.dart';

import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'game_state.g.dart';

abstract class GameState implements Built<GameState, GameStateBuilder> {
  factory GameState([void Function(GameStateBuilder b) updates]) = _$GameState;

  GameState._();

  RequestState get getRequestState;

  ActiveGameState get activeGameState;

  @nullable
  CurrentGameState get currentGameState;

  @nullable
  UserPossessionState get possessions;

  @nullable
  TargetState get target;

  @nullable
  Account get account;

  BuiltList<GameEvent> get events;

  @nullable
  GameContext get currentGameContext;

  static GameState initial() => GameState(
        (b) => b
          ..getRequestState = RequestState.idle
          ..activeGameState = ActiveGameState.waitingForStart()
          ..events = ListBuilder(),
      );
}
