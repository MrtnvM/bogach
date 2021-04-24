import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/chart/dot/dot_user_progress_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProgressTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final game = useCurrentGame((g) => g);

    return Container(
      padding: const EdgeInsets.only(top: 24, left: 32, right: 32),
      height: 400,
      child: DotUserProgressChart(game: game),
    );
  }
}
