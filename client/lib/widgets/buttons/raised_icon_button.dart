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
    return RaisedButton(
      padding: const EdgeInsets.all(6),
      shape: const CircleBorder(),
      onPressed: onPressed,
      color: buttonColor,
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
