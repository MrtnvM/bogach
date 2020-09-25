import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/game/game_state.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/models/domain/active_game_state/active_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

final gameReducer = Reducer<GameState>()
  ..on<LogoutAsyncAction>((state, action) => GameState.initial())
  ..on<SendPlayerMoveAsyncAction>(
    (state, action) => state.rebuild((s) {
      final sendingEventIndex = s.currentGame?.currentEvents?.indexWhere(
        (e) => e.id == action.eventId,
      );

      if (sendingEventIndex == null || sendingEventIndex < 0) {
        FirebaseCrashlytics.instance.recordError(
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
  ..on<SetGameParticipantsProfiles>(
    (state, action) => state.rebuild((s) {
      s.participantProfiles = StoreList<UserProfile>(action.userProfiles);
    }),
  );
