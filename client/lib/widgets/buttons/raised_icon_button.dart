import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class RaisedIconButton extends StatelessWidget {
  const RaisedIconButton({
    @required this.icon,
    @required this.onPressed,
    this.size = 28,
    this.buttonColor = ColorRes.grey,
    this.iconColor = ColorRes.mainBlack,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color buttonColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(size),
        ),
        child: Icon(
          icon,
          size: size,
          color: iconColor,
        ),
      ),
    );
  }
}
