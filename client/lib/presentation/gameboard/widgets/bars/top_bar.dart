import 'dart:io';

import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/progress_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopBar extends HookWidget {
  const TopBar({required this.onMenuTap});

  static const bottomOffset = 24.0;
  static const topBarContentHeight = 130.0;

  static double getHeight(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return topBarContentHeight + statusBarHeight;
  }

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final notchSize = useNotchSize();
    final height = getHeight(context);
    final progressBarTopPadding = notchSize.top > 20 && Platform.isIOS
        ? 0.0
        : (height - AccountBar.height - ProgressBar.height - notchSize.top) / 2;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: bottomOffset,
            child: Container(
              decoration: BoxDecoration(
                color: ColorRes.mainGreen,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(200),
                    blurRadius: 3,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: height - bottomOffset,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: Styles.linearGradient,
            ),
            child: const _CirclesBackground(),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: AccountBar(),
          ),
          Positioned(
            top: notchSize.top + progressBarTopPadding,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ProgressBar(onMenuTap: onMenuTap),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CirclesBackground extends StatelessWidget {
  const _CirclesBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: Image(
            image: AssetImage(Images.bgCircleRight),
            fit: BoxFit.contain,
            width: 93,
            height: 87,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Image(
            image: AssetImage(Images.bgCircleLeft),
            fit: BoxFit.contain,
            width: 119,
            height: 81,
          ),
        ),
      ],
    );
  }
}
