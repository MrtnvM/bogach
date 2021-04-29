import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class TableRow extends StatelessWidget {
  const TableRow({this.title, this.value});

  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title!,
            style: Styles.tableRowTitle,
          ),
        ),
        Text(
          value!,
          style: Styles.tableRowValue,
        ),
      ],
    );
  }
}
