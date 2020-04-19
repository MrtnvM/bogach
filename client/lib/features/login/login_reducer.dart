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
    (state, action) =>
        state.rebuild((s) => s.loginRequestState = action.requestState),
  );
