import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/domain/active_game_state.dart';
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
          ..currentValue = action.data.possessions.assets.sum
          ..type = action.data.target.type;

        final currentState = s.activeGameState;
        var newGameState = currentState;

        final gameEvents = action.data.events;
        final shouldUpdateGame = currentState.maybeWhen(
          waitingForStart: () => true,
          gameEvent: (eventId) => eventId == null,
          orElse: () => false,
        );

        if (shouldUpdateGame && gameEvents.isNotEmpty) {
          newGameState = ActiveGameState.gameEvent(gameEvents.first.id);
        }

        return s
          ..getRequestState = RequestState.success
          ..possessions = action.data.possessions.toBuilder()
          ..target = targetBuilder
          ..activeGameState = newGameState
          ..account = action.data.account
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
    (state, action) => state.rebuild(
      (s) {
        final eventIndex = s.events.build().indexWhere(
              (e) => e.id == action.eventId,
            );

        if (eventIndex < 0) {
          return;
        }

        if (eventIndex < s.events.length - 1) {
          final nextEventId = s.events[eventIndex + 1].id;
          s.activeGameState = ActiveGameState.gameEvent(nextEventId);
          return;
        }

        if (eventIndex == s.events.length - 1) {
          s.activeGameState = ActiveGameState.monthResult();
          return;
        }
      },
    ),
  )
  ..on<GoToNewMonthAction>(
    (state, action) => state.rebuild(
      (s) {
        final newFirstEvent = s.events.isNotEmpty ? s.events.first : null;
        s.activeGameState = ActiveGameState.gameEvent(newFirstEvent?.id);
      },
    ),
  );
