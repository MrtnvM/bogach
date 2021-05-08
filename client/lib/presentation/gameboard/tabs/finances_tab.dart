import 'package:cash_flow/presentation/gameboard/possessions/assets_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/expenses_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/incomes_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/liabilities_list.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FinancesTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: 24 + TopBar.bottomOffset,
        bottom: 24,
      ),
      children: [
        _buildList(IncomesList(), isFirst: true),
        _buildList(ExpensesList()),
        _buildList(AssetsList()),
        _buildList(LiabilitiesList()),
      ],
    );
  }

  Widget _buildList(Widget listWidget, {bool isFirst = false}) {
    return Container(
      padding: EdgeInsets.only(top: isFirst ? 0 : 16, left: 16, right: 16),
      child: listWidget,
    );
  }
}
