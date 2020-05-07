import 'package:cash_flow/resources/strings.dart';
import 'package:json_annotation/json_annotation.dart';

enum TargetType {
  @JsonValue('cash')
  cash,
  @JsonValue('passive_income')
  passiveIncome,
}

String mapTargetTypeToString(TargetType type) {
  switch (type) {
    case TargetType.cash:
      return Strings.targetTypeCash;

    case TargetType.passiveIncome:
      return Strings.targetTypePassiveIncome;

    default:
      return '';
  }
}
