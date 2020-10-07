import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/presentation/gameboard/widgets/chart/dot/dot_chart_hooks.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/src/widgets/framework.dart';
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
    );
  }
}
