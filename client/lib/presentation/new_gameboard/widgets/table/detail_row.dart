import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  const DetailRow({this.title, this.value, this.details = const []});

  final String title;
  final String value;

  final List<String> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: [
          Expanded(
            child: Text(title, style: Styles.bodyBlack),
          ),
          Text(value, style: Styles.bodyBlack),
        ]),
        for (var detail in details) ...[
          const SizedBox(height: 4),
          Text(
            detail,
            style: Styles.body1.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorRes.primaryGreyColor,
            ),
          ),
        ]
      ],
    );
  }
}
