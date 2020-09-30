import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';

class SetGameContextAction extends BaseAction {
  SetGameContextAction(this.gameContext);

  final GameContext gameContext;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      return s.game.currentGameContext = gameContext;
    });
  }
}
