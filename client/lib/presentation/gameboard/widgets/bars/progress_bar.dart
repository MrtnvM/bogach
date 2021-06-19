import 'dart:math';

import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/gameboard_timer.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressBar extends HookWidget {
  const ProgressBar({Key? key, required this.onMenuTap}) : super(key: key);

  static const height = 66.0;

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final userId = useUserId()!;
    final target = useCurrentGame((g) => g!.target)!;
    final currentTargetValue = useCurrentGame(
      (g) => mapGameToCurrentTargetValue(g!, userId),
    )!;
    final progress = currentTargetValue / target.value;

    return Container(
      padding: const EdgeInsets.only(left: 24.0, right: 8),
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RoundProgress(progress: progress),
          const SizedBox(width: 16),
          _ProgressTitle(
            target: target,
            currentValue: currentTargetValue,
          ),
          const Spacer(),
          _MenuButton(onMenuTap: onMenuTap),
        ],
      ),
    );
  }
}

class _ProgressTitle extends HookWidget {
  const _ProgressTitle({
    Key? key,
    required this.target,
    required this.currentValue,
  }) : super(key: key);

  final Target target;
  final double currentValue;

  @override
  Widget build(BuildContext context) {
    final currentMonth = useCurrentGame((g) => g!.state.monthNumber);
    final monthLimit = useCurrentGame((g) => g!.config.monthLimit);
    final gameboardTutorial = useGameboardTutorial();

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
            key: gameboardTutorial?.monthKey,
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
  const _MenuButton({Key? key, required this.onMenuTap}) : super(key: key);

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onMenuTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Icon(Icons.menu, color: Colors.white),
      ),
    );
  }
}

class _RoundProgress extends HookWidget {
  const _RoundProgress({Key? key, required this.progress}) : super(key: key);

  final double progress;

  @override
  Widget build(BuildContext context) {
    final gameTutorial = useGameboardTutorial();
    final isMultiplayer = useIsMultiplayerGame();
    const size = 56.0;
    final progressValue = min(max(progress, 0.0), 1.0);

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
      child: Stack(
        children: [
          CircularPercentIndicator(
            radius: size,
            lineWidth: 5.0,
            animation: true,
            percent: progressValue,
            center: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(progressValue * 100).toInt()}%',
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
          if (isMultiplayer)
            Opacity(
              opacity: 0.9,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: GameboardTimer(),
              ),
            ),
        ],
      ),
    );
  }
}
