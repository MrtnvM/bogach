import 'package:cash_flow/presentation/gameboard/game_events/common/candles/candle_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_chart/flutter_k_chart.dart';

class ChartWidget extends HookWidget {
  const ChartWidget({
    @required this.data,
    this.padding,
    this.backgroundColor,
  });

  final List<CandleData> data;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final chartData = useMemoized(() {
      final lineEntities = <KLineEntity>[];

      for (var i = 0; i < data.length; i++) {
        final candle = data[i];
        final change = i > 0 ? data[i].close - data[i - 1].close : 0.0;
        final changeInPercent = i > 0 ? change / data[i - 1].close * 100 : 0.0;

        lineEntities.add(KLineEntity.fromCustom(
          open: candle.open,
          close: candle.close,
          high: candle.high,
          low: candle.low,
          time: candle.time.millisecondsSinceEpoch,
          change: change,
          vol: 0,
          amount: 0,
          ratio: changeInPercent,
        ));
      }

      return lineEntities;
    }, [data]);

    return Container(
      height: height,
      padding: padding,
      width: double.infinity,
      child: KChartWidget(
        chartData,
        bgColor: [backgroundColor, backgroundColor],
        isLine: false,
        mainState: MainState.NONE,
        volHidden: true,
        secondaryState: SecondaryState.NONE,
        fixedLength: 2,
        timeFormat: TimeFormat.YEAR_MONTH_DAY,
        isChinese: false,
        selectionLineColor: Colors.black54,
        lineChartColor: Colors.black87,
        lineChartFillColor: Colors.black26,
        maxMinColor: Colors.black87,
      ),
    );
  }
}
