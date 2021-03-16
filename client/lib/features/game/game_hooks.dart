import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game/type/game_type.dart';

T useCurrentGame<T>(T Function(Game) converter) {
  return useGlobalState((s) => converter(s.game.currentGame));
}

CurrentGameState useCurrentGameState() {
  return useGlobalState((s) => s.game.currentGame.state);
}

Account useAccount() {
  final userId = useUserId();
  final account = useCurrentGame((g) => g?.participants[userId]?.account);
  final defaultAccount = Account(cashFlow: 0, cash: 0, credit: 0);
  return account ?? defaultAccount;
}

bool useIsMultiplayerGame() {
  return useCurrentGame((g) => g?.type == GameType.multiplayer());
}

bool useIsQuestGame() {
  return useCurrentGame((g) => g?.config?.level != null);
}

bool useIsGameOver() {
  return useCurrentGame((g) => g?.state?.gameStatus == GameStatus.gameOver);
}

bool useIsCurrentParticipantWinGame() {
  final userId = useUserId();
  final isWin = useCurrentGame((g) {
    final participantProgress = g != null //
        ? g.participants[userId].progress.progress
        : 0;

    return participantProgress >= 1;
  });

  return isWin;
}
