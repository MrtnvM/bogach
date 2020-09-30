import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';

class OnGameErrorAction extends BaseAction {
  OnGameErrorAction(this.error);

  final dynamic error;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      s.game.activeGameState = s.game.activeGameState.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(
          sendingEventIndex: -1,
        ),
        orElse: () => s.game.activeGameState,
      );
    });
  }

  @override
  String toString() {
    return '${super.toString()}' '\n$error';
  }
}
