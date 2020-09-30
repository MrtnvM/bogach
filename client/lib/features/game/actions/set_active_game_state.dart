import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';

class SetActiveGameState extends BaseAction {
  SetActiveGameState(this.activeGameState);

  final ActiveGameState activeGameState;

  @override
  AppState reduce() {
    return state.rebuild(
      (s) => s.game.activeGameState = activeGameState,
    );
  }
}
