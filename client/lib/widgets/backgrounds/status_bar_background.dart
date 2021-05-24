import 'dart:io';
import 'dart:math';

import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class StatusBarBackground extends StatelessWidget {
  const StatusBarBackground({Key? key, this.scrollOffset}) : super(key: key);

  final double? scrollOffset;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = min(MediaQuery.of(context).padding.top, 36.0);
    final offset = max(scrollOffset ?? 0, 0.0);
    final opacity = min(offset / 50, 1.0);

    if (!Platform.isIOS) {
      return Container();
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        color: ColorRes.mainGreen.withAlpha(200),
        width: double.infinity,
        height: statusBarHeight,
      ),
    );
  }
}
