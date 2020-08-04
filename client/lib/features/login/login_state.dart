library login_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'login_state.g.dart';

abstract class LoginState implements Built<LoginState, LoginStateBuilder> {
  factory LoginState([void Function(LoginStateBuilder b) updates]) =
      _$LoginState;

  LoginState._();

  RequestState get loginRequestState;

  @nullable
  UserProfile get currentUser;

  static LoginState initial() =>
      LoginState((b) => b..loginRequestState = RequestState.idle);
}
