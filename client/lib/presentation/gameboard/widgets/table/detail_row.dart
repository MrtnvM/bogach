import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  const DetailRow({
    @required this.title,
    @required this.value,
    this.details = const [],
  })  : assert(title != null),
        assert(value != null);

  final String title;
  final String value;
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: [
          Expanded(child: Text(title, style: Styles.bodyBlack)),
          Text(value, style: Styles.bodyBlack),
        ]),
        for (final detail in details) ...[
          const SizedBox(height: 4),
          Text(detail, style: Styles.tableRowDetails),
        ]
      ],
    );
  }
}
