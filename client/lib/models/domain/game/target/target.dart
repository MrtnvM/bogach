import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/possession_state/incomes/income.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'target.freezed.dart';
part 'target.g.dart';

@freezed
class Target with _$Target {
  factory Target({
    required TargetType type,
    required double value,
  }) = _Target;

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);
}

enum TargetType {
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

double mapGameToCurrentTargetValue(Game game, String userId) {
  switch (game.target.type) {
    case TargetType.cash:
      return game.participants[userId]?.account.cash ?? 0;

    case TargetType.passiveIncome:
      final totalIncome = game.participants[userId]?.possessionState.incomes
          .fold<double>(0.0, (sum, i) => sum + i.value) ?? 0;

      final salary = game.participants[userId]?.possessionState.incomes
          .where((i) => i.type == IncomeType.salary)
          .fold<double>(0.0, (sum, i) => sum + i.value) ?? 0;

      final passiveIncome = totalIncome - salary;
      return passiveIncome;

    default:
      return 0;
  }
}

String mapGameToCurrentTargetStringValue(Game game, String userId) {
  final targetValue = mapGameToCurrentTargetValue(game, userId);

  switch (game.target.type) {
    case TargetType.cash:
      return targetValue.toPrice();

    case TargetType.passiveIncome:
      return targetValue.toPrice();

    default:
      return 0.toPrice();
  }
}
