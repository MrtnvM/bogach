import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({this.text, this.color, this.maxLines});
  final String text;
  final Color color;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        print('You pressed $text button');
      },
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      color: color,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints.expand(),
        child: AutoSizeText(
          text,
          minFontSize: 10,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          maxLines: maxLines,
          style: TextStyle(
            color: ColorRes.primaryWhiteColor,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
