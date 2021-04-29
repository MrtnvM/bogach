import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    required this.child,
    Key? key,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorRes.primaryWhiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 3,
            spreadRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }
}
