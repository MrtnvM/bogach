import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class OnGameErrorAction extends BaseAction {
  OnGameErrorAction(this.error, this.gameContext);

  final dynamic error;
  final GameContext gameContext;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      setErrorOperationStateIfNeeded(Operation.createGame, s);
      setErrorOperationStateIfNeeded(Operation.createQuestGame, s);
      setErrorOperationStateIfNeeded(Operation.createRoomGame, s);

      final gameId = gameContext.gameId;
      final activeGameState = s.game.activeGameStates[gameId];

      s.game.activeGameStates[gameId] = activeGameState.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(
          sendingEventIndex: -1,
        ),
        orElse: () => activeGameState,
      );
    });
  }

  @override
  String toString() {
    return '${super.toString()}' '\n$error';
  }

  void setErrorOperationStateIfNeeded(Operation operation, AppStateBuilder s) {
    final operationState = state.getOperationState(operation);

    if (operationState == OperationState.inProgress) {
      s.operationsState[operation] = OperationState.error;
    }
  }
}
