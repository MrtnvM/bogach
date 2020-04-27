library login_state;

import 'package:built_value/built_value.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'login_state.g.dart';

abstract class LoginState
    implements Built<LoginState, LoginStateBuilder> {
  factory LoginState(
          [void Function(LoginStateBuilder b) updates]) =
      _$LoginState;

  LoginState._();

  RequestState get loginRequestState;

  static LoginState initial() => LoginState(
        (b) => b
          ..loginRequestState = RequestState.idle,
      );
}
