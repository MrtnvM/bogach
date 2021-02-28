import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/widgets.dart';

class GameTypeTitle extends StatelessWidget {
  const GameTypeTitle({
    @required this.text,
    this.actionWidget,
  }) : assert(text != null);

  final String text;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 16),
      child: Row(children: [
        Expanded(
          child: Text(
            text,
            style: Styles.head.copyWith(color: ColorRes.black),
          ),
        ),
        if (actionWidget != null) ...[
          const SizedBox(width: 16),
          actionWidget,
        ]
      ]),
    );
  }
}
