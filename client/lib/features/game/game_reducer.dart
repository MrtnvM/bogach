import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/models/state/target_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final gameStateReducer = Reducer<GameState>()
  ..on<ListenGameStateStartAction>(
    (state, action) => state.rebuild(
      (s) => s..getRequestState = RequestState.inProgress,
    ),
  )
  ..on<ListenGameStateSuccessAction>(
    (state, action) => state.rebuild(
      (s) {
        final targetBuilder = TargetStateBuilder()
          ..value = action.data.target.value
          ..currentValue = action.data.possessions.assets.sum
          ..type = action.data.target.type;

        return s
          ..getRequestState = RequestState.success
          ..possessions = action.data.possessions.toBuilder()
          ..target = targetBuilder
          ..events = action.data.events.toBuilder();
      },
    ),
  )
  ..on<ListenGameStateErrorAction>(
    (state, action) => state.rebuild(
      (s) => s.getRequestState = RequestState.error,
    ),
  )
  ..on<SetGameContextAction>(
    (state, action) => state.rebuild(
      (s) => s.currentGameContext = action.context,
    ),
  );
