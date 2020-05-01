import 'package:json_annotation/json_annotation.dart';

enum TargetType {
  @JsonValue('cash')
  cash,
  @JsonValue('passive_income')
  passiveIncome,
}
