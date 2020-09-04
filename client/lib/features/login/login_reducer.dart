import 'package:cash_flow/core/utils/mappers/current_user_mappers.dart';
import 'package:cash_flow/features/game/game_actions.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/login/login_state.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

final loginReducer = Reducer<LoginState>()
  ..on<LoginViaFacebookAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.loginRequestState = action.requestState;

      action.onSuccess((user) => s.currentUser = user);
    }),
  )
  ..on<LoginViaGoogleAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.loginRequestState = action.requestState;

      action.onSuccess((user) => s.currentUser = user);
    }),
  )
  ..on<LoginViaAppleAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.loginRequestState = action.requestState;

      action..onSuccess((user) => s.currentUser = user);
    }),
  )
  ..on<SetCurrentUserAction>(
    (state, action) => state.rebuild(
      (s) => s..currentUser = mapToUserProfile(action.user),
    ),
  )
  ..on<LoadCurrentUserProfileAsyncAction>(
    (state, action) => state.rebuild(
      (s) {
        action.onSuccess((user) => s.currentUser = user);
      },
    ),
  )
  ..on<UpdateCurrentQuestIndexAction>(
    (state, action) => state.rebuild(
      (s) {
        s.currentUser = s.currentUser.copyWith(
          currentQuestIndex: action.newQuestIndex,
        );
      },
    ),
  );
