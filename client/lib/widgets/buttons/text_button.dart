import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  const TextButton({
    this.text,
    this.onPressed,
    this.color = Colors.white,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text,
            style: Styles.body1.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            )),
      ),
    );
  }
}
