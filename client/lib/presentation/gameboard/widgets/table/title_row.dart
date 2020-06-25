import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class TitleRow extends StatelessWidget {
  const TitleRow({@required this.title, @required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Text(title, style: Styles.bodyBlack),
            const SizedBox(width: 20),
            if (value != null)
              Expanded(
                  child: Text(
                value,
                style: Styles.bodyBlack,
                textAlign: TextAlign.end,
              )),
          ],
        ),
      ],
    );
  }
}
