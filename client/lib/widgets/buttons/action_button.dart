import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    this.text,
    this.onPressed,
    this.color,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {},
      color: color,
      child: Text(text, style: Styles.body1.copyWith(color: ColorRes.white)),
    );
  }
}
