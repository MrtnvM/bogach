import 'dart:math';

import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class ProgressBar extends HookWidget {
  const ProgressBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final target = useCurrentGame((g) => g.target);
    final currentTargetValue = useCurrentGame(
      (g) => mapGameToCurrentTargetValue(g, userId),
    );
    final progress = currentTargetValue / target.value;

    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 14.0, right: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        color: ColorRes.primaryWhiteColor,
      ),
      child: Column(
        children: [
          _ProgressTitle(target: target, currentValue: currentTargetValue),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              height: 20,
              child: Stack(
                children: [
                  _ProgressLine(progress),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border:
                          Border.all(color: ColorRes.progressBarBorderColor),
                    ),
                  ),
                  _MaxProgressValue(target.value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressTitle extends StatelessWidget {
  const _ProgressTitle({
    Key key,
    this.target,
    this.currentValue,
  }) : super(key: key);

  final Target target;
  final double currentValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Text(
            '${mapTargetTypeToString(target.type)}:  ',
            textAlign: TextAlign.left,
            style: Styles.tableHeaderTitleBlack,
          ),
          Text(
            currentValue.toPrice(),
            textAlign: TextAlign.left,
            style: Styles.tableHeaderTitleBlack,
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine(this.progress);
  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth * max(progress, 0),
          decoration: const BoxDecoration(
//            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: ColorRes.primaryYellowColor,
          ),
        );
      },
    );
  }
}

class _MaxProgressValue extends StatelessWidget {
  const _MaxProgressValue(this.value);
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        value.toPrice(),
        style: Styles.tableHeaderTitleBlack.copyWith(fontSize: 10),
      ),
    );
  }
}
