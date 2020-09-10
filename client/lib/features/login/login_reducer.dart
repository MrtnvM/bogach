import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/login/login_state.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

final loginReducer = Reducer<LoginState>()
  ..on<LogoutAsyncAction>((state, action) => LoginState.initial())
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
    (state, action) => state.rebuild((s) => s.currentUser = action.user),
  )
  ..on<LoadCurrentUserProfileAsyncAction>(
    (state, action) => state.rebuild(
      (s) {
        action.onSuccess((user) => s.currentUser = user);
      },
    ),
  )
  ..on<UpdateCurrentQuestIndexAsyncAction>(
    (state, action) => state.rebuild(
      (s) {
        action.onSuccess((user) => s.currentUser = user);
      },
    ),
  );
