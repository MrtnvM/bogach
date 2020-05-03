import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/game/game_reducer.dart';
import 'package:cash_flow/features/login/login_reducer.dart';
import 'package:cash_flow/features/purchase/purchase_reducer.dart';
import 'package:cash_flow/features/new_game/new_game_reducer.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class AppReducer extends Reducer<AppState> {
  @override
  AppState reduce(AppState state, Action action) {
    return state.rebuild((s) {
      s.login = loginReducer.reduce(state.login, action).toBuilder();
      s.gameState =
          gameStateReducer.reduce(state.gameState, action).toBuilder();
      s.newGameState =
          newGameReducer.reduce(state.newGameState, action).toBuilder();
      s.purchaseState =
          purchaseReducer.reduce(state.purchaseState, action).toBuilder();
    });
  }
}
