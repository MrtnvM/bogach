import 'package:cash_flow/presentation/gameboard/game_events/common/candles/candle_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:k_chart/renderer/base_chart_renderer.dart';

class ChartWidget extends HookWidget {
  const ChartWidget({
    @required this.data,
    this.padding,
    this.backgroundColor,
    this.height = 250,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return KChartWidget(
            chartData,
            bgColor: [backgroundColor, backgroundColor],
            isLine: false,
            mainState: MainState.NONE,
            volHidden: true,
            secondaryState: SecondaryState.NONE,
            fixedLength: 0,
            dateFormat: const ['M'],
            infoWindowDateFormat: const ['MM'],
            language: KChartLanguage.russian,
            selectionLineColor: Colors.grey.withAlpha(40),
            lineChartColor: Colors.green,
            lineChartFillColor: Colors.green,
            maxMinColor: Colors.green,
            chartVerticalPadding: 24,
            priceFormatter: (price) => price.toPrice(),
            gridColumns: constraints.maxWidth ~/ 45,
            style: ChartStyle.defaultStyle.copyWith(
              pointWidth: 16,
              candleWidth: 10,
            ),
          );
        },
      ),
    );
  }
}
