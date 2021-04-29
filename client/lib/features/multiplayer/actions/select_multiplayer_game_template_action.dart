import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';

class SelectMultiplayerGameTemplateAction extends BaseAction {
  SelectMultiplayerGameTemplateAction(this.gameTemplate);

  final GameTemplate gameTemplate;

  @override
  AppState reduce() {
    return state.rebuild((s) {
      s.multiplayer.selectedGameTemplate = gameTemplate;
      s.multiplayer.createdRoomId = null;
    });
  }
}
