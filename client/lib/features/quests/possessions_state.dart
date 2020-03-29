library possessions_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/network/request_state.dart';
import 'package:cash_flow/models/state/posessions_state/user_possession_state.dart';

part 'possessions_state.g.dart';

abstract class PossessionsState
    implements Built<PossessionsState, PossessionsStateBuilder> {
  factory PossessionsState([void Function(PossessionsStateBuilder b) updates]) =
      _$PossessionsState;

  PossessionsState._();

  RequestState get getRequestState;

  @nullable
  UserPossessionState get userPossessionsState;

  static PossessionsState initial() => PossessionsState((b) => b
    ..getRequestState = RequestState.idle);
}
