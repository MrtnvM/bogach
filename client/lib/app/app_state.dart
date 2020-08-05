library app_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/features/login/login_state.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_state.dart';
import 'package:cash_flow/features/purchase/purchase_state.dart';
import 'package:cash_flow/features/new_game/new_game_state.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'app_state.g.dart';

abstract class AppState
    implements Built<AppState, AppStateBuilder>, GlobalState {
  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  AppState._();

  LoginState get login;
  PurchaseState get purchase;

  GameState get game;
  NewGameState get newGame;
  MultiplayerState get multiplayer;

  static AppState initial() {
    return AppState(
      (b) => b
        ..login = LoginState.initial().toBuilder()
        ..purchase = PurchaseState.initial().toBuilder()
        ..game = GameState.initial().toBuilder()
        ..newGame = NewGameState.initial().toBuilder()
        ..multiplayer = MultiplayerState.initial().toBuilder(),
    );
  }
}
