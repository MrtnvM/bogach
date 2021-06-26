import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';

class SetActiveGameState extends BaseAction {
  SetActiveGameState(this.gameContext, this.activeGameState);

  final GameContext gameContext;
  final ActiveGameState activeGameState;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      final gameId = gameContext.gameId;
      s.game.activeGameStates![gameId] = activeGameState;
    });
  }
}
