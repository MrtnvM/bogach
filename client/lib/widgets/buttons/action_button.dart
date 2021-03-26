import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    this.text,
    this.textStyle,
    this.onPressed,
    this.color = ColorRes.grass,
    this.withRoundedBorder = false,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;
  final TextStyle textStyle;
  final bool withRoundedBorder;

  @override
  Widget build(BuildContext context) {
    final titleStyle = textStyle ??
        Styles.body1.copyWith(
          color: ColorRes.white,
        );

    return RaisedButton(
      shape: withRoundedBorder == true
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
          : null,
      onPressed: onPressed,
      color: color,
      child: Text(text, style: titleStyle),
    );
  }
}
