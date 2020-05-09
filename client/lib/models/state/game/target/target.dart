import 'package:freezed_annotation/freezed_annotation.dart';

part 'target.freezed.dart';
part 'target.g.dart';

@freezed
abstract class Target with _$Target {
  factory Target(
    @required TargetType type,
    @required double value,
  ) = _Target;

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);
}

enum TargetType {
  cash,
  @JsonValue('passive_income')
  passiveIncome,
}
