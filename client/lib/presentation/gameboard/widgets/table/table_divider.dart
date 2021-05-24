import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class TableDivider extends StatelessWidget {
  const TableDivider({
    Key? key,
    this.color = ColorRes.newGameBoardInvestmentsDividerColor,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 32,
      thickness: 1,
      color: color,
    );
  }
}
