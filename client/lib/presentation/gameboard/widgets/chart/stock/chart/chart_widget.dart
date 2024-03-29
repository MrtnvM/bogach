import 'package:cash_flow/presentation/gameboard/game_events/common/candles/candle_data.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/renderer/base_chart_renderer.dart';

class ChartWidget extends HookWidget {
  const ChartWidget({
    required this.candles,
    this.padding,
    this.backgroundColor = Colors.white,
    this.height = 250,
  });

  final List<CandleData> candles;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final chartData = useChartData(candles);
    final chartStyle = ChartStyle()
      ..pointWidth = 16
      ..candleWidth = 10;
    final chartColors = ChartColors();

    return Container(
      height: height,
      padding: padding,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return KChartWidget(
            chartData,
            chartStyle,
            chartColors,
            bgColor: [backgroundColor, backgroundColor],
            isLine: false,
            dateFormat: const ['M'],
            infoWindowDateFormat: const ['MM'],
            language: KChartLanguage.russian,
            priceFormatter: (price) => price.toPrice(),
            gridColumns: constraints.maxWidth ~/ 45,
          );
        },
      ),
    );
  }
}

List<KLineEntity> useChartData(List<CandleData> candles) {
  final chartData = useMemoized(() {
    final lineEntities = <KLineEntity>[];

    for (var i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final change = i > 0 ? candles[i].close - candles[i - 1].close : 0.0;
      final changeInPercent = i > 0 ? change / candles[i - 1].close * 100 : 0.0;

      lineEntities.add(KLineEntity.fromCustom(
        open: candle.open,
        close: candle.close,
        high: candle.high,
        low: candle.low,
        time: candle.time?.millisecondsSinceEpoch,
        change: change,
        amount: 0,
        ratio: changeInPercent,
      ));
    }

    return lineEntities;
  }, [candles]);

  return chartData;
}
