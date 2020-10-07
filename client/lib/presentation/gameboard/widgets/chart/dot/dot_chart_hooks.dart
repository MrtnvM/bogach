import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:charts_flutter/flutter.dart';

import 'dot_model.dart';

List<List<DotModel>> useDotModels(Game game) {
  final initialCash = game.config.initialCash;
  final firstDot = DotModel(
    xValue: 0,
    yValue: initialCash,
  );

  final listOfPlayerDots = <List<DotModel>>[];

  var maxMonthValue = 0;

  final currentMonth = game.state.monthNumber;

  game.state.participantsProgress.forEach((userId, progress) {
    final dots = <DotModel>[];
    dots.add(firstDot);

    progress.monthResults.forEach((month, monthResults) {
      final intMonth = int.parse(month) + 1;

      if (currentMonth != intMonth) {
        final dot = DotModel(
          xValue: intMonth,
          yValue: monthResults.cash.toInt(),
        );
        dots.add(dot);

        if (intMonth > maxMonthValue) {
          maxMonthValue = intMonth;
        }
      }
    });

    listOfPlayerDots.add(dots);
  });

  final gameDifference = game.target.value.toInt() - initialCash;
  final optimalStep = gameDifference ~/ game.config.monthLimit;
  final optimalPathDots = <DotModel>[];
  optimalPathDots.add(firstDot);

  for (var monthIndex = 0; monthIndex < maxMonthValue; monthIndex++) {
    final differenceFromStart = (monthIndex + 1) * optimalStep;
    final optimalCashValue = initialCash + differenceFromStart;

    final dot = DotModel(
      xValue: monthIndex + 1,
      yValue: optimalCashValue,
    );
    optimalPathDots.add(dot);
  }

  listOfPlayerDots.add(optimalPathDots);

  return listOfPlayerDots;
}

List<Series> useGraphicSeries(List<List<DotModel>> dotModels) {
  var graphicId = 0;

  final series = dotModels.map((subListDots) {
    graphicId++;

    return Series<DotModel, int>(
      id: graphicId.toString(),
      colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
      domainFn: (model, _) => model.xValue,
      measureFn: (model, _) => model.yValue,
      data: subListDots,
    );
  }).toList();

  return series;
}
