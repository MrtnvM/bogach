import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({
    @required this.onPressed,
    @required this.text,
    this.textStyle,
    this.color = Colors.white,
    this.disabledColor,
    this.borderRadius = 4,
    this.padding = 14,
  });

  final Function() onPressed;
  final String text;
  final TextStyle textStyle;
  final Color color;
  final Color disabledColor;
  final double borderRadius;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      disabledColor: disabledColor ?? color.withAlpha(180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: color,
      padding: EdgeInsets.all(padding),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle ?? Styles.defaultColorButtonText,
        ),
      ),
    );
  }
}
