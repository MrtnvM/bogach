import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game/type/game_type.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/current_game_data_provider.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

String? useCurrentGameId() {
  final context = useContext();
  final gameId = CurrentGameDataProvider.of(context).gameId;
  return gameId;
}

T? useCurrentGame<T>(T Function(Game?) converter) {
  final gameId = useCurrentGameId();
  final game = useGlobalState((s) => converter(s.game.games[gameId!]));
  return game;
}

GameContext useCurrentGameContext() {
  final gameId = useCurrentGameId()!;
  final userId = useUserId()!;

  final gameContext = useMemoized(
    () => GameContext(userId: userId, gameId: gameId),
    [gameId, userId],
  );

  return gameContext;
}

ActiveGameState? useCurrentActiveGameState() {
  final gameId = useCurrentGameId();
  final activeGameState =
      useGlobalState((s) => s.game.activeGameStates[gameId]);
  return activeGameState;
}

CurrentGameState? useCurrentGameState() {
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

bool useIsSingleplayerGame() {
  return useCurrentGame(
        (g) => g?.config.level == null && g?.type == GameType.singleplayer(),
      ) ??
      false;
}

bool useIsMultiplayerGame() {
  return useCurrentGame((g) => g?.type == GameType.multiplayer()) ?? false;
}

bool useIsQuestGame() {
  return useCurrentGame((g) => g?.config.level != null) ?? false;
}

bool useIsGameOver() {
  return useCurrentGame((g) => g?.state.gameStatus == GameStatus.gameOver) ??
      false;
}

bool useIsCurrentParticipantWinGame() {
  final userId = useUserId();
  final isWin = useCurrentGame((g) {
    final participantProgress = g != null //
        ? g.participants[userId]?.progress.progress ?? 0
        : 0;

    return participantProgress >= 1;
  });

  return isWin ?? false;
}

int useCurrentParticipantBenchmark() {
  final userId = useUserId();
  const defaultBenchmarkPercentValue = 0;
  final percent = useCurrentGame((g) {
    if (g == null) {
      return defaultBenchmarkPercentValue;
    }

    final winnerIndex = g.state.winners.indexWhere(
      (p) => p.userId == userId,
    );

    if (winnerIndex < 0) {
      return defaultBenchmarkPercentValue;
    }

    final winner = g.state.winners[winnerIndex];
    return winner.benchmark;
  });

  return percent ?? defaultBenchmarkPercentValue;
}

void useGameWatcher() {
  final gameContext = useCurrentGameContext();
  final dispatch = useDispatcher();

  useEffect(() {
    if (gameContext.gameId == TUTORIAL_GAME_ID) {
      return null;
    }

    dispatch(StartGameAction(gameContext));
    return () => dispatch(StopGameAction(gameContext.gameId));
  }, []);
}
