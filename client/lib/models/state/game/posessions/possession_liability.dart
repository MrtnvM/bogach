library possession_liability;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/network/responses/possessions_state/liability_response_model.dart';

part 'possession_liability.g.dart';

abstract class PossessionLiability
    implements Built<PossessionLiability, PossessionLiabilityBuilder> {
  factory PossessionLiability(
          [void Function(PossessionLiabilityBuilder b) updates]) =
      _$PossessionLiability;

  PossessionLiability._();

  String get name;

  LiabilityType get type;

  int get value;
}
