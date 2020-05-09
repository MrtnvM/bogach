import 'package:freezed_annotation/freezed_annotation.dart';

part 'liability.freezed.dart';
part 'liability.g.dart';

@freezed
abstract class Liability with _$Liability {
  factory Liability({
    @required String name,
    @required LiabilityType type,
    @required double monthlyPayment,
    @required double value,
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
