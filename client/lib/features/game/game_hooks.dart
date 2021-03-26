import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game/type/game_type.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/current_game_data_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

String useCurrentGameId() {
  final context = useContext();
  final gameId = CurrentGameDataProvider.of(context).gameId;
  return gameId;
}

T useCurrentGame<T>(T Function(Game) converter) {
  final gameId = useCurrentGameId();
  final game = useGlobalState((s) => converter(s.game.games[gameId]));
  return game;
}

GameContext useCurrentGameContext() {
  final gameId = useCurrentGameId();
  final userId = useUserId();

  final gameContext = useMemoized(
    () => GameContext(userId: userId, gameId: gameId),
    [gameId, userId],
  );

  return gameContext;
}

ActiveGameState useCurrentActiveGameState() {
  final gameId = useCurrentGameId();
  final activeGameState =
      useGlobalState((s) => s.game.activeGameStates[gameId]);
  return activeGameState;
}

CurrentGameState useCurrentGameState() {
  final gameId = useCurrentGameId();
  final gameState = useGlobalState((s) => s.game.games[gameId]?.state);
  return gameState;
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
