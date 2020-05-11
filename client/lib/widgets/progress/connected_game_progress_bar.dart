import 'dart:math';

import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/models/domain/game/possession_state/incomes/income.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/progress/game_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConnectedGameProgressBar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final target = useCurrentGame((g) => g.target);

    return GameProgressBar(
      name: _getTargetType(target.type),
      currentValue: _getTargetCurrentValue(target),
      maxValue: target.value,
    );
  }

  String _getTargetType(TargetType type) {
    final typeNames = {
      TargetType.cash: Strings.targetTypeCash,
      TargetType.passiveIncome: Strings.passiveIncomePerMonth,
    };

    return typeNames[type] ?? '';
  }

  double _getTargetCurrentValue(Target target) {
    final userId = useUserId();
    final account = useCurrentGame((g) => g.accounts[userId]);
    final incomes = useCurrentGame((g) => g.possessionState[userId].incomes);

    switch (target.type) {
      case TargetType.cash:
        return account.cash;

      case TargetType.passiveIncome:
        final salary = incomes.fold<double>(
          0.0,
          (sum, income) =>
              sum + (income.type == IncomeType.salary ? income.value : 0),
        );

        final totalIncome = incomes.fold<double>(
          0.0,
          (sum, income) => sum + income.value,
        );

        final passiveIncome = totalIncome - salary;
        return max(0.0, passiveIncome.toDouble());

      default:
        return 0.0;
    }
  }
}
