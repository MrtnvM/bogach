import 'package:auto_size_text/auto_size_text.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    this.text,
    this.onPressed,
    this.color = ColorRes.grass,
    this.textColor = ColorRes.white,
  });

  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return onPressed == null
        ? ActionButton(
            text: text,
            onPressed: onPressed,
          )
        : OutlineButton(
            color: color,
            onPressed: onPressed,
            borderSide: BorderSide(color: color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            highlightedBorderColor: color,
            child: AutoSizeText(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: Styles.body1,
            ),
          );
  }
}
