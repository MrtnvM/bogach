import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/features/login/login_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final loginReducer = Reducer<LoginState>()
  ..on<LoginAsyncAction>(
        (state, action) => state.rebuild((s) => action
      ..onStart(() {
        return s.loginRequestState = RequestState.inProgress;
      })
      ..onSuccess((_) {
        return s.loginRequestState = RequestState.success;
      })
      ..onError((_) {
        return s.loginRequestState = RequestState.error;
      })),
  );
