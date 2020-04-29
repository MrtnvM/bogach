import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({
    @required this.onPressed,
    @required this.text,
  });

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: ColorRes.yellow,
      padding: const EdgeInsets.all(14),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
