// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'liability.freezed.dart';
part 'liability.g.dart';

@freezed
class Liability with _$Liability {
  factory Liability({
    required String name,
    @JsonKey(unknownEnumValue: LiabilityType.other, defaultValue: LiabilityType.other)
        required LiabilityType type,
    required double monthlyPayment,
    required double value,
  }) = _Liability;

  factory Liability.fromJson(Map<String, dynamic> json) =>
      _$LiabilityFromJson(json);
}

enum LiabilityType {
  mortgage,
  @JsonValue('business_credit')
  businessCredit,
  other
}
