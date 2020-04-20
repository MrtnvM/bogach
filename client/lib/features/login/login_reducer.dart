import 'package:cash_flow/core/utils/mappers/current_user_mappers.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/login/login_state.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final loginReducer = Reducer<LoginState>()
  ..on<LoginAsyncAction>(
    (state, action) =>
        state.rebuild((s) => s.loginRequestState = action.requestState),
  )
  ..on<LoginViaFacebookAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.loginRequestState = action.requestState;

      action
        ..onSuccess((currentUser) => s.currentUser = currentUser.toBuilder());
    }),
  )
  ..on<LoginViaGoogleAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.loginRequestState = action.requestState;

      action
        ..onSuccess((currentUser) => s.currentUser = currentUser.toBuilder());
    }),
  )
  ..on<SetCurrentUserAction>(
    (state, action) => state.rebuild(
        (s) => s..currentUser = mapUserToCurrentUser(action.user)?.toBuilder()),
  );
