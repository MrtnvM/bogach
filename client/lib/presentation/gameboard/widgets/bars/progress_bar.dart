import 'dart:math';

import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      height: 66,
      child: Row(
        children: [
          _RoundProgress(progress: progress),
          const SizedBox(width: 16),
          _ProgressTitle(
            target: target,
            currentValue: currentTargetValue,
          ),
          const Spacer(),
          const _MenuButton(),
        ],
      ),
    );
  }
}

class _ProgressTitle extends HookWidget {
  const _ProgressTitle({
    Key key,
    this.target,
    this.currentValue,
  }) : super(key: key);

  final Target target;
  final double currentValue;

  @override
  Widget build(BuildContext context) {
    final currentMonth = useCurrentGame((g) => g.state.monthNumber);
    final monthLimit = useCurrentGame((g) => g.config?.monthLimit);

    final monthPast = monthLimit != null
        ? '${Strings.month}: $currentMonth / $monthLimit'
        : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${mapTargetTypeToString(target.type)}  ',
          textAlign: TextAlign.left,
          style: Styles.tableHeaderTitleBlack.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${currentValue.toInt().toPrice()} ${Strings.from} '
          '${target.value.toPrice()}',
          textAlign: TextAlign.left,
          style: Styles.tableHeaderTitleBlack.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
        if (monthPast != null)
          Text(
            monthPast,
            textAlign: TextAlign.left,
            style: Styles.tableHeaderTitleBlack.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.menu, color: Colors.white);
  }
}

class _RoundProgress extends HookWidget {
  const _RoundProgress({Key key, @required this.progress}) : super(key: key);

  final double progress;

  @override
  Widget build(BuildContext context) {
    final gameTutorial = useGameboardTutorial();
    const size = 56.0;

    return Container(
      key: gameTutorial?.currentProgressKey,
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: ColorRes.mainGreen,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 8),
        ],
      ),
      child: CircularPercentIndicator(
        radius: size,
        lineWidth: 5.0,
        animation: true,
        percent: min(max(progress, 0), 1),
        center: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.yellow,
        backgroundColor: Colors.white,
        animateFromLastPercent: true,
      ),
    );
  }
}
