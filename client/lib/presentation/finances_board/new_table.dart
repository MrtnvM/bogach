import 'package:cash_flow/presentation/finances_board/title_row.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class Table extends StatelessWidget {
  const Table({
    Key key,
    this.title,
    this.titleValue,
    this.rows,
  }) : super(key: key);

  final String title;
  final String titleValue;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 2.0,
              spreadRadius: 2.0),
        ],
        color: ColorRes.primaryWhiteColor,
      ),
      child: Column(
        children: <Widget>[
          TitleRow(
            title: title,
            value: titleValue,
          ),
          TableDivider(),
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) TableDivider(),
          ]
        ],
      ),
    );
  }
}

class TableDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 24,
        thickness: 1,
        color: ColorRes.newGameBoardInvestmentsDividerColor);
  }
}
