import 'package:cash_flow/presentation/finances_board/styles.dart';
import 'package:flutter/material.dart';

class TableRow extends StatelessWidget {
  TableRow({this.title, this.value});

  final String title;
  final String value;

  final Stylez stylez = Stylez();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Text(
          title,
          style: stylez.normal16,
        ),
      ),
      Text(
        value,
        style: stylez.normal16,
      ),
    ]);
  }
}
