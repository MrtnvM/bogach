import 'package:cash_flow/presentation/gameboard/possessions/assets_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/expenses_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/incomes_list.dart';
import 'package:cash_flow/presentation/gameboard/possessions/liabilities_list.dart';
import 'package:flutter/material.dart';

class PossessionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        IncomesList(),
        const SizedBox(height: 32),
        ExpensesList(),
        const SizedBox(height: 32),
        AssetsList(),
        const SizedBox(height: 32),
        LiabilitiesList(),
        const SizedBox(height: 32),
      ],
    );
  }
}
