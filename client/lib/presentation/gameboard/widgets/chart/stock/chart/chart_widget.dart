import 'package:cash_flow/presentation/gameboard/game_events/common/candles/candle_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChartWidget extends HookWidget {
  const ChartWidget({
    required this.candles,
    this.padding,
    this.backgroundColor,
    this.height = 250,
  });

  final List<CandleData> candles;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    // TODO(Artem): return back charts
    return const SizedBox();
  }
}
