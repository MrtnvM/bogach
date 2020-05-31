import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

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
          final currentEventIndex = game.state.participantProgress[userId];

          newActiveGameState = s.activeGameState.maybeWhen(
            gameEvent: (eventIndex, isSent) => ActiveGameState.gameEvent(
              eventIndex: currentEventIndex,
              isSending: currentEventIndex == eventIndex,
            ),
            orElse: () => ActiveGameState.gameEvent(
              eventIndex: currentEventIndex,
              isSending: false,
            ),
          );
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
        gameEvent: (gameEventState) =>
            gameEventState.copyWith(isSending: false),
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
      action.onStart(() {
        s.activeGameState = s.activeGameState.maybeMap(
          gameEvent: (gameEventState) =>
              gameEventState.copyWith(isSending: true),
          orElse: () => s.activeGameState,
        );
      });

      action.onError((error) {
        s.activeGameState = s.activeGameState.maybeMap(
          gameEvent: (gameEventState) =>
              gameEventState.copyWith(isSending: false),
          orElse: () => s.activeGameState,
        );
      });
    }),
  );
