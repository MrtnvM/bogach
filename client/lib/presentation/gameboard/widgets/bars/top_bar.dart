import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/progress_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopBar extends HookWidget {
  static const height = 174.0;

  @override
  Widget build(BuildContext context) {
    final notchSize = useNotchSize();
    const bottomOffset = 24.0;

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
          Positioned(
            top: notchSize.top,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                ProgressBar(),
                SizedBox(height: 16),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: AccountBar(),
          )
        ],
      ),
    );
  }
}

class _CirclesBackground extends StatelessWidget {
  const _CirclesBackground({Key key}) : super(key: key);

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
