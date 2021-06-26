import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/presentation/gameboard/widgets/chart/dot/dot_chart_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DotUserProgressChart extends HookWidget {
  const DotUserProgressChart({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final series = useSeries(game);

    return SfCartesianChart(
      primaryXAxis: NumericAxis(interval: 1, plotOffset: 20),
      primaryYAxis: NumericAxis(numberFormat: NumberFormat.decimalPattern()),
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: series,
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
