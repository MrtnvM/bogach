import 'package:cash_flow/features/quests/possessions_actions.dart';
import 'package:cash_flow/features/quests/possessions_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final possessionsReducer = Reducer<PossessionsState>()
  ..on<ListenPossessionsStartAction>((state, action) =>
      state.rebuild((s) => s..getRequestState = RequestState.inProgress))
  ..on<ListenPossessionsSuccessAction>((state, action) => state.rebuild((s) => s
    ..getRequestState = RequestState.success
    ..userPossessionsState = action.state.toBuilder()))
  ..on<ListenPossessionsErrorAction>((state, action) =>
      state.rebuild((s) => s..getRequestState = RequestState.error));
