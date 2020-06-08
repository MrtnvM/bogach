library game_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';

import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'game_state.g.dart';

abstract class GameState implements Built<GameState, GameStateBuilder> {
  factory GameState([void Function(GameStateBuilder b) updates]) = _$GameState;

  GameState._();

  RequestState get getRequestState;
  RequestState get startNewMonthRequestState;

  ActiveGameState get activeGameState;

  @nullable
  Game get currentGame;

  @nullable
  GameContext get currentGameContext;

  static GameState initial() => GameState(
        (b) => b
          ..getRequestState = RequestState.idle
          ..startNewMonthRequestState = RequestState.idle
          ..activeGameState = ActiveGameState.waitingForStart(),
      );
}
