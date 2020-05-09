import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';

String useUserId() {
  return useGlobalState((s) => s.login.currentUser.userId);
}

T useCurrentGame<T>(T Function(Game) convertor) {
  return useGlobalState((s) => convertor(s.gameState.currentGame));
}
