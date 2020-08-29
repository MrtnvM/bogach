import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

final gameReducer = Reducer<GameState>()
  ..on<StartGameAction>(
    (state, action) => state.rebuild(
      (s) => s
        ..getRequestState = RequestState.inProgress
        ..activeGameState = ActiveGameState.waitingForStart(),
    ),
  )
  ..on<OnGameStateChangedAction>(
    (state, action) => state.rebuild(
      (s) {
        var newActiveGameState = s.activeGameState;
        final game = action.game;

        if (game.state.gameStatus == GameStatus.playersMove) {
          final userId = s.currentGameContext.userId;
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
            newActiveGameState = s.activeGameState.maybeWhen(
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

        return s
          ..getRequestState = RequestState.success
          ..currentGame = game
          ..activeGameState = newActiveGameState;
      },
    ),
  )
  ..on<OnGameErrorAction>(
    (state, action) => state.rebuild((s) {
      s.getRequestState = RequestState.error;

      s.activeGameState = s.activeGameState.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(
          sendingEventIndex: -1,
        ),
        orElse: () => s.activeGameState,
      );
    }),
  )
  ..on<SetGameContextAction>(
    (state, action) => state.rebuild(
      (s) => s.currentGameContext = action.gameContext,
    ),
  )
  ..on<SendPlayerMoveAsyncAction>(
    (state, action) => state.rebuild((s) {
      final sendingEventIndex = s.currentGame?.currentEvents?.indexWhere(
        (e) => e.id == action.eventId,
      );

      if (sendingEventIndex == null || sendingEventIndex < 0) {
        Crashlytics.instance.recordError(
            'Game Reducer: Event with id ${action.eventId} not found', null);
        return;
      }

      action.onStart(() {
        s.activeGameState = s.activeGameState.maybeMap(
          gameEvent: (gameEventState) => gameEventState.copyWith(
            sendingEventIndex: sendingEventIndex,
          ),
          orElse: () => s.activeGameState,
        );
      });

      action.onError((error) {
        s.activeGameState = s.activeGameState.maybeMap(
          gameEvent: (gameEventState) => gameEventState.copyWith(
            sendingEventIndex: -1,
          ),
          orElse: () => s.activeGameState,
        );
      });
    }),
  )
  ..on<StartNewMonthAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.startNewMonthRequestState = action.requestState;
    }),
  )
  ..on<SetGameParticipnatsProfiles>(
    (state, action) => state.rebuild((s) {
      s.participantProfiles = StoreList<UserProfile>(action.userProfiles);
    }),
  );

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
