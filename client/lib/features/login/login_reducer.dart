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
    (state, action) => state.rebuild((s) => action
      ..onStart(() => s..loginRequestState = RequestState.inProgress)
      ..onSuccess((currentUser) => s
        ..loginRequestState = RequestState.success
        ..currentUser = currentUser.toBuilder())
      ..onError((_) => s..loginRequestState = RequestState.error)),
  )
  ..on<LoginViaGoogleAsyncAction>(
    (state, action) => state.rebuild((s) => action
      ..onStart(() => s..loginRequestState = RequestState.inProgress)
      ..onSuccess((currentUser) {
        return s
          ..loginRequestState = RequestState.success
          ..currentUser = currentUser.toBuilder();
      })
      ..onError((_) => s..loginRequestState = RequestState.error)),
  )
  ..on<SetCurrentUserAction>(
    (state, action) => state.rebuild(
        (s) => s..currentUser = mapUserToCurrentUser(action.user)?.toBuilder()),
  );
