import 'package:cash_flow/presentation/new_gameboard/finances_board/styles.dart';
import 'package:flutter/material.dart';

class TitleRow extends StatelessWidget {
  TitleRow({this.title, this.value});

  final String title;
  final String value;

  final stylez = Stylez();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Expanded(child: Text(title, style: stylez.title)),
            Text(value, style: stylez.title),
          ],
        ),
      ],
    );
  }
}
