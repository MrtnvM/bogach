import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/models/domain/game/possession_state/incomes/income.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class IncomesList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final incomes = useCurrentGame((g) => g.possessionState[userId].incomes);

    final totalIncome = incomes.fold<double>(0.0, (s, i) => s + i.value);
    final salary = _calculateSum(incomes, IncomeType.salary);
    final investment = _calculateSum(incomes, IncomeType.investment);
    final business = _calculateSum(incomes, IncomeType.business);
    final realty = _calculateSum(incomes, IncomeType.realty);
    final other = _calculateSum(incomes, IncomeType.other);

    return InfoTable(
      title: Strings.incomes,
      titleValue: totalIncome.toPrice(),
      rows: [
        TitleRow(title: Strings.salary, value: salary.toPrice()),
        TitleRow(title: Strings.investments, value: investment.toPrice()),
        TitleRow(title: Strings.business, value: business.toPrice()),
        TitleRow(title: Strings.realty, value: realty.toPrice()),
        TitleRow(title: Strings.other, value: other.toPrice()),
      ],
    );
  }

  double _calculateSum(List<Income> incomes, IncomeType type) {
    return incomes.fold(0.0, (s, i) => s + (i.type == type ? i.value : 0));
  }
}
