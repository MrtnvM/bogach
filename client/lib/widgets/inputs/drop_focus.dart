import 'package:flutter/material.dart';

class DropFocus extends StatelessWidget {
  const DropFocus({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: drop,
      child: child,
    );
  }

  static void drop() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }
}
