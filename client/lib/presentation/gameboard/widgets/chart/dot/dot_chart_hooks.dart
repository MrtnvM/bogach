import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:charts_flutter/flutter.dart';

import 'dot_model.dart';

List<List<DotModel>> useDotModels(Game game) {
  final listOfPlayerDots = <List<DotModel>>[];

  var maxMonthValue = 0;
  game.state.participantsProgress.forEach((userId, progress) {
    final dots = <DotModel>[];
    progress.monthResults.forEach((month, monthResults) {
      final intMonth = int.parse(month);

      final dot = DotModel(
        xValue: int.parse(month),
        yValue: monthResults.cash.toInt(),
      );
      dots.add(dot);

      if (intMonth > maxMonthValue) {
        maxMonthValue = intMonth;
      }
    });

    listOfPlayerDots.add(dots);
  });

  return listOfPlayerDots;
}

List<Series> useGraphicSeries(List<List<DotModel>> dotModels) {
  final series = dotModels.map((subListDots) {
    return Series<DotModel, int>(
      id: 'random id',
      colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
      domainFn: (model, _) => model.xValue,
      measureFn: (model, _) => model.yValue,
      data: subListDots,
    );
  }).toList();

  return series;
}
