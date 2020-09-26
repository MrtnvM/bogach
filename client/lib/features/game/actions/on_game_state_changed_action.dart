import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';

class OnGameStateChangedAction extends BaseAction {
  OnGameStateChangedAction(this.game);

  final Game game;

  @override
  FutureOr<AppState> reduce() {
    return state.rebuild((s) {
      var newActiveGameState = s.game.activeGameState;

      if (game.state.gameStatus == GameStatus.playersMove) {
        final userId = s.game.currentGameContext.userId;
        final progress = game.state.participantsProgress[userId];
        if (progress.status == ParticipantProgressStatus.monthResult) {
          final waitingPlayerList = getParticipantIdsForWaiting(
            userId,
            game.state.participantsProgress,
          );

          newActiveGameState = waitingPlayerList.isEmpty
              ? ActiveGameState.monthResult()
              : ActiveGameState.waitingPlayers(waitingPlayerList);
        }

        if (progress.status == ParticipantProgressStatus.playerMove) {
          newActiveGameState = s.game.activeGameState.maybeWhen(
            gameEvent: (eventIndex, sendingEventIndex) {
              return ActiveGameState.gameEvent(
                eventIndex: progress.currentEventIndex,
                sendingEventIndex: sendingEventIndex,
              );
            },
            orElse: () => ActiveGameState.gameEvent(
              eventIndex: progress.currentEventIndex,
              sendingEventIndex: -1,
            ),
          );
        }
      }

      if (game.state.gameStatus == GameStatus.gameOver) {
        newActiveGameState = ActiveGameState.gameOver(
          winners: game.state.winners,
          monthNumber: game.state.monthNumber,
        );
      }

      s.game
        ..currentGame = game
        ..activeGameState = newActiveGameState;

      final isGameCompleted = game.state.gameStatus == GameStatus.gameOver;
      final isQuestGame = game.config.level != null;

      if (isGameCompleted && isQuestGame) {
        s.newGame.currentGameForLevels[game.config.level] = null;
      }
    });
  }
}

List<String> getParticipantIdsForWaiting(
  String myUserId,
  Map<String, ParticipantProgress> participantsProgress,
) {
  final progress = participantsProgress[myUserId];
  final myCurrentMonth = progress.currentMonthForParticipant;

  final waitingPlayerList = participantsProgress.entries
      .where((entry) => entry.key != myUserId)
      .where((entry) {
        final progress = entry.value;
        final participantMonth = progress.currentMonthForParticipant;

        final isMoving = participantMonth == myCurrentMonth &&
            progress.status != ParticipantProgressStatus.monthResult;

        final didNotStartNewMonth =
            progress.currentMonthForParticipant < myCurrentMonth;

        return isMoving || didNotStartNewMonth;
      })
      .map((entry) => entry.key)
      .toList();

  return waitingPlayerList;
}
