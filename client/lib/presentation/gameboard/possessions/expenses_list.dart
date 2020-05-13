import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class ExpensesList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final expenses = useCurrentGame((g) => g.possessionState[userId].expenses);
    final totalExpense = expenses.fold<double>(
      0.0,
      (sum, item) => sum + item.value,
    );

    return InfoTable(
      title: Strings.expenses,
      titleValue: totalExpense.toPrice(),
      rows: [
        for (var expense in expenses)
          TitleRow(title: expense.name, value: expense.value.toPrice())
      ],
    );
  }
}
