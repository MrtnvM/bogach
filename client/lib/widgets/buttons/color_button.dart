import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({
    @required this.onPressed,
    @required this.text,
    this.color = Colors.white,
  });

  final Function() onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: color,
      padding: const EdgeInsets.all(14),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: ColorRes.mainBlack,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
