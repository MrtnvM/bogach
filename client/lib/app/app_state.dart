library app_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/features/login/login_state.dart';
import 'package:cash_flow/features/new_game/new_game_state.dart';
import 'package:cash_flow/features/registration/registration_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'app_state.g.dart';

abstract class AppState
    implements Built<AppState, AppStateBuilder>, GlobalState {
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  AppState._();

  LoginState get login;

  RegistrationState get registration;

  GameState get gameState;

  NewGameState get newGameState;

  static AppState initial() {
    return AppState(
      (b) => b
        ..login = LoginState.initial().toBuilder()
        ..registration = RegistrationState.initial().toBuilder()
        ..gameState = GameState.initial().toBuilder()
        ..newGameState = NewGameState.initial().toBuilder(),
    );
  }
}
