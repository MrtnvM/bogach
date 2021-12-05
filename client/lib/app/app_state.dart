library app_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/features/config/config_state.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_state.dart';
import 'package:cash_flow/features/profile/profile_state.dart';
import 'package:cash_flow/features/new_game/new_game_state.dart';
import 'package:cash_flow/features/recommendations/recommendations_state.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'app_state.g.dart';

abstract class AppState
    implements Built<AppState, AppStateBuilder>, GlobalState {
  factory AppState([void Function(AppStateBuilder)? updates]) = _$AppState;

  AppState._();

  ProfileState get profile;
  RecommendationsState get recommendations;

  GameState get game;
  NewGameState get newGame;
  MultiplayerState get multiplayer;

  ConfigState get config;

  @override
  BuiltMap<Object, OperationState> get operationsState;

  @override
  T updateOperation<T extends GlobalState>(
    Object? operationKey,
    OperationState operationState,
  ) {
    if (operationKey == null) {
      return this as T;
    }

    final GlobalState newState = rebuild(
      (s) => s.operationsState[operationKey] = operationState,
    );
    return newState as T;
  }

  @override
  OperationState getOperationState(Object operationKey) {
    return operationsState[operationKey] ?? OperationState.idle;
  }

  static AppState initial() {
    return AppState(
      (b) => b
        ..profile = ProfileState.initial().toBuilder()
        ..recommendations = RecommendationsState.initial().toBuilder()
        ..game = GameState.initial().toBuilder()
        ..newGame = NewGameState.initial().toBuilder()
        ..multiplayer = MultiplayerState.initial().toBuilder()
        ..config = ConfigState.initial(),
    );
  }
}
