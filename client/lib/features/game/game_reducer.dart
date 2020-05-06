import 'dart:math';

import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/domain/active_game_state.dart';
import 'package:cash_flow/models/domain/game_data.dart';
import 'package:cash_flow/models/network/responses/target_type.dart';
import 'package:cash_flow/models/state/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/state/game/target/target_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final gameStateReducer = Reducer<GameState>()
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
        final targetBuilder = TargetStateBuilder()
          ..value = action.data.target.value
          ..currentValue = _targetCurrentValue(action.data)
          ..type = action.data.target.type;

        var newActiveGameState = s.activeGameState;
        final gameState = action.data.gameState;

        if (gameState.gameStatus == GameStatus.playersMove) {
          final userId = s.currentGameContext.userId;
          final currentEventIndex = gameState.participantProgress[userId];

          newActiveGameState = s.activeGameState.maybeWhen(
            gameEvent: (eventIndex, isSent) => ActiveGameState.gameEvent(
              eventIndex: currentEventIndex,
              isSent: currentEventIndex == eventIndex,
            ),
            orElse: () => ActiveGameState.gameEvent(
              eventIndex: currentEventIndex,
              isSent: false,
            ),
          );
        }

        if (gameState.gameStatus == GameStatus.gameOver) {
          newActiveGameState = ActiveGameState.gameOver(
            winners: gameState.winners,
            monthNumber: gameState.monthNumber,
          );
        }

        return s
          ..getRequestState = RequestState.success
          ..possessions = action.data.possessions.toBuilder()
          ..target = targetBuilder
          ..activeGameState = newActiveGameState
          ..account = action.data.account
          ..currentGameState = action.data.gameState
          ..events = action.data.events.toBuilder();
      },
    ),
  )
  ..on<OnGameErrorAction>(
    (state, action) => state.rebuild(
      (s) => s.getRequestState = RequestState.error,
    ),
  )
  ..on<SetGameContextAction>(
    (state, action) => state.rebuild(
      (s) => s.currentGameContext = action.gameContext,
    ),
  )
  ..on<SendPlayerMoveAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.activeGameState = s.activeGameState.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(isSent: true),
        orElse: () => s.activeGameState,
      );
    }),
  )
  ..on<SkipPlayerMoveAction>(
    (state, action) => state.rebuild((s) {
      s.activeGameState = s.activeGameState.maybeMap(
        gameEvent: (gameEventState) => gameEventState.copyWith(isSent: true),
        orElse: () => s.activeGameState,
      );
    }),
  );

double _targetCurrentValue(GameData gameData) {
  switch (gameData.target.type) {
    case TargetType.cash:
      return gameData.account.cash;

    case TargetType.passiveIncome:
      final incomes = gameData.possessions.incomes;
      final passiveIncome = incomes.sum - incomes.salary;
      return max(0.0, passiveIncome.toDouble());

    default:
      return 0.0;
  }
}
