import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class TableDivider extends StatelessWidget {
  const TableDivider({Key key, this.color}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 24,
      thickness: 1,
      color: color ?? ColorRes.newGameBoardInvestmentsDividerColor,
    );
  }
}
