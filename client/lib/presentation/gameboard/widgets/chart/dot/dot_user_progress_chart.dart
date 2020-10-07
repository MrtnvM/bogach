import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/presentation/gameboard/widgets/chart/dot/dot_chart_hooks.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DotUserProgressChart extends HookWidget {
  DotUserProgressChart({this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final dotModels = useDotModels(game);
    final series = useGraphicSeries(dotModels);

    return LineChart(
      series,
      animate: false,
      defaultRenderer: LineRendererConfig(
        includePoints: true,
      ),
      behaviors: [
        LinePointHighlighter(
          showHorizontalFollowLine: LinePointHighlighterFollowLineType.none,
          showVerticalFollowLine: LinePointHighlighterFollowLineType.none,
        ),
        SeriesLegend(
          position: BehaviorPosition.bottom,
          outsideJustification: OutsideJustification.end,
          desiredMaxRows: 2,
          cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
        )
      ],
    );
  }
}
