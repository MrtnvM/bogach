library registration_state;

import 'package:built_value/built_value.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

part 'registration_state.g.dart';

abstract class RegistrationState
    implements Built<RegistrationState, RegistrationStateBuilder> {
  factory RegistrationState(
          [void Function(RegistrationStateBuilder b) updates]) =
      _$RegistrationState;

  RegistrationState._();

  RequestState get requestState;

  static RegistrationState initial() => RegistrationState(
        (b) => b..requestState = RequestState.idle,
      );
}
