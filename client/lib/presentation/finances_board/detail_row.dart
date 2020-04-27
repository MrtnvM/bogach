import 'package:cash_flow/presentation/finances_board/styles.dart';
import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  DetailRow({this.title, this.value, this.details = const []});

  final String title;
  final String value;

  final List<String> details;

  final Stylez stylez = Stylez();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: [
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
        ]),
        for (var detail in details) Text(detail, style: stylez.detail)
      ],
    );
  }
}
