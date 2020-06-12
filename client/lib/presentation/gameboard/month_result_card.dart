import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/current_game_state/month_result.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/table_divider.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class MonthResultCard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final month = useCurrentGame((g) => g.state.monthNumber);
    final monthResults = useCurrentGame(
      (g) => g.state.participantsProgress[userId].monthResults,
    );
    final calculateChange = useMonthChangeCalculator();

    final currentResults = monthResults['${month - 1}'];
    final cashFlow = currentResults.totalIncome - currentResults.totalExpense;
    final cashChange = calculateChange((r) => r.cash);
    final incomeChange = calculateChange((r) => r.totalIncome);
    final expenseChange = calculateChange((r) => r.totalExpense);
    final assetsChange = calculateChange((r) => r.totalAssets);
    final liabilityChange = calculateChange((r) => r.totalLiabilities);

    const green = ColorRes.green;
    const red = ColorRes.errorRed;

    final color = (value, shouldReverse) {
      if (double.parse(value.toStringAsFixed(1)) == 0.0) {
        return ColorRes.mainBlack;
      }

      if (value > 0 && !shouldReverse) {
        return green;
      }

      return red;
    };

    return CardContainer(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSubtitle('${Strings.financialResults}:'),
          const TableDivider(),
          _buildItem(
            title: '${Strings.incomes}:',
            value: currentResults.totalIncome.toPrice(),
            color: green,
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.expenses}:',
            value: currentResults.totalExpense.toPrice(),
            color: red,
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.total}:',
            value: cashFlow.toPrice(),
            color: cashFlow >= 0 ? green : red,
          ),
          const TableDivider(),
          const SizedBox(height: 20),
          _buildSubtitle('${Strings.financialResultsChange}:'),
          const TableDivider(),
          _buildItem(
            title: '${Strings.cash}:',
            value: cashChange.toPercent(),
            color: color(cashChange, false),
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.incomes}:',
            value: incomeChange.toPercent(),
            color: color(incomeChange, false),
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.expenses}:',
            value: expenseChange.toPercent(),
            color: color(expenseChange, true),
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.assets}:',
            value: assetsChange.toPercent(),
            color: color(assetsChange, false),
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.liabilities}:',
            value: liabilityChange.toPercent(),
            color: color(liabilityChange, true),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            Strings.monthResult,
            style: Styles.tableHeaderTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(subtitle, style: Styles.bodyBlackSemibold),
    );
  }

  Widget _buildItem({String title, String value, Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(child: Text(title, style: Styles.bodyBlack)),
              Text(
                value,
                style: Styles.bodyBlackSemibold.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemDivider() {
    return TableDivider(
      color: ColorRes.newGameBoardInvestmentsDividerColor.withAlpha(150),
    );
  }
}

double Function(double Function(MonthResult)) useMonthChangeCalculator() {
  final userId = useUserId();
  final month = useCurrentGame((g) => g.state.monthNumber);
  final monthResults = useCurrentGame(
    (g) => g.state.participantsProgress[userId].monthResults,
  );

  final previousResults = monthResults['${month - 2}'];
  final currentResults = monthResults['${month - 1}'];

  final calculateChange = (double Function(MonthResult result) selector) {
    final currentValue = selector(currentResults);
    final previousValue = selector(previousResults);
    final change = (currentValue - previousValue) / previousValue;
    return change * 100;
  };

  return calculateChange;
}
