library target_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/network/responses/target_type.dart';

part 'target_state.g.dart';

abstract class TargetState
    implements Built<TargetState, TargetStateBuilder> {
  factory TargetState([void Function(TargetStateBuilder b) updates]) =
  _$TargetState;

  TargetState._();

  int get value;

  int get currentValue;

  TargetType get type;
}
