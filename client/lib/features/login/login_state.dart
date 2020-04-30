library login_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/state/user/current_user.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'login_state.g.dart';

abstract class LoginState implements Built<LoginState, LoginStateBuilder> {
  factory LoginState([void Function(LoginStateBuilder b) updates]) =
      _$LoginState;

  LoginState._();

  RequestState get loginRequestState;

  RequestState get resetPasswordRequestState;

  @nullable
  CurrentUser get currentUser;

  static LoginState initial() => LoginState((b) => b
    ..loginRequestState = RequestState.idle
    ..resetPasswordRequestState = RequestState.idle);
}
