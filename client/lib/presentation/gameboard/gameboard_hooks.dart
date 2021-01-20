import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useGameboardAnalytics() {
  final gameExists = useCurrentGame((g) => g != null);
  final isMultiplayer = useIsMultiplayerGame();
  final isQuest = useIsQuestGame();
  final isGameOver = useIsGameOver();

  useEffect(() {
    AnalyticsSender.gameStart();

    return () {
      if (gameExists && isGameOver) {
        AnalyticsSender.gameExit();
      }
    };
  }, []);

  final isGameStartEventsSent = useState(false);
  useEffect(() {
    if (!gameExists || isGameStartEventsSent.value) {
      return null;
    }

    isGameStartEventsSent.value = true;

    if (isMultiplayer) {
      AnalyticsSender.multiplayerGameStart();
    } else if (isQuest) {
      AnalyticsSender.questStarted();
    } else {
      AnalyticsSender.singleplayerGameStart();
    }

    return null;
  }, [gameExists, isMultiplayer, isQuest]);

  final isGameEndEventsSent = useState(false);
  final isWin = useIsCurrentParticipantWinGame();
  useEffect(() {
    if (!gameExists || !isGameOver || isGameEndEventsSent.value) {
      return null;
    }

    isGameEndEventsSent.value = true;
    AnalyticsSender.gameEnd();

    if (isMultiplayer) {
      return;
    }

    if (isWin) {
      AnalyticsSender.gameWin();
    } else {
      AnalyticsSender.gameLoss();
    }

    return null;
  }, [gameExists, isGameOver, isWin, isMultiplayer]);
}
