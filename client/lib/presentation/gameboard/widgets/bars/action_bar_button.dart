import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class ActionBarButton extends StatelessWidget {
  const ActionBarButton({
    @required this.text,
    @required this.color,
    this.maxTitleLines = 1,
    this.onPressed,
  });

  final String text;
  final Color color;
  final int maxTitleLines;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: RaisedButton(
        onPressed: onPressed,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: color,
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints.expand(),
          child: AutoSizeText(
            text,
            minFontSize: 10,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            maxLines: maxTitleLines,
            style: Styles.body1,
          ),
        ),
      ),
    );
  }
}
