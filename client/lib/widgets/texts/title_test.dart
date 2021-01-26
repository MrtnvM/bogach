import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText(this.text);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 19,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
