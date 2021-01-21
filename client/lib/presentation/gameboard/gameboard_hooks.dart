import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useGameboardAnalytics() {
  final gameExists = useCurrentGame((g) => g != null);
  final templateId = useCurrentGame((g) => g?.config?.gameTemplateId);
  final isMultiplayer = useIsMultiplayerGame();
  final isQuest = useIsQuestGame();
  final quest = useCurrentGame((g) => g?.config?.level);
  final isGameOver = useIsGameOver();
  final isWin = useIsCurrentParticipantWinGame();

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

      SessionTracker.multiplayerGame.start();
      SessionTracker.multiplayerGame.setAttribute('template_id', templateId);
    } else if (isQuest) {
      AnalyticsSender.questStart(quest);

      SessionTracker.quest.start();
      SessionTracker.quest.setAttribute('quest_id', quest);
    } else {
      AnalyticsSender.singleplayerGameStart();

      SessionTracker.singleplayerGame.start();
      SessionTracker.singleplayerGame.setAttribute('template_id', templateId);
    }

    return null;
  }, [gameExists]);

  final isGameEndEventsSent = useState(false);
  useEffect(() {
    if (!gameExists || !isGameOver || isGameEndEventsSent.value) {
      return null;
    }

    isGameEndEventsSent.value = true;
    AnalyticsSender.gameEnd();

    if (isMultiplayer) {
      AnalyticsSender.multiplayerGameEnd();
      SessionTracker.multiplayerGame.stop();
      return;
    }

    if (!isQuest) {
      AnalyticsSender.singleplayerGameEnd();
      SessionTracker.singleplayerGame.stop();
    }

    if (isWin) {
      AnalyticsSender.gameWin();
    } else {
      AnalyticsSender.gameLoss();
    }

    return null;
  }, [gameExists, isGameOver, isWin]);

  useEffect(() {
    if (gameExists && isQuest && isGameOver) {
      SessionTracker.quest.stop();

      if (isWin) {
        AnalyticsSender.questCompleted(quest);
      } else {
        AnalyticsSender.questFailed(quest);
      }
    }
    return null;
  }, [gameExists, isGameOver]);
}
