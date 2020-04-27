import 'package:cash_flow/features/registration/registration_actions.dart';
import 'package:cash_flow/features/registration/registration_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

final registrationReducer = Reducer<RegistrationState>()
  ..on<RegisterAsyncAction>(
    (state, action) => state.rebuild((s) => action
      ..onStart(() => s.requestState = RequestState.inProgress)
      ..onSuccess((_) => s.requestState = RequestState.success)
      ..onError((_) => s.requestState = RequestState.error)),
  );
