import 'dart:io';

import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class StatusBarBackground extends StatelessWidget {
  const StatusBarBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    if (Platform.isIOS) {
      return Container();
    }

    return Container(
      color: ColorRes.mainGreen.withAlpha(50),
      width: double.infinity,
      height: statusBarHeight,
    );
  }
}
