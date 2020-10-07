import 'package:cash_flow/models/domain/game/current_game_state/participant_progress.dart';
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

  final currentMonth = game.state.monthNumber;

  _fillDotsForOptimal(
    gameTarget: game.target.value.toInt(),
    firstDot: firstDot,
    currentMonth: currentMonth,
    initialCash: initialCash,
    monthLimit: game.config.monthLimit,
    dotsList: listOfPlayerDots,
  );

  _fillDotsForPlayers(
    participantsProgress: game.state.participantsProgress,
    firstDot: firstDot,
    currentMonth: currentMonth,
    listOfPlayerDots: listOfPlayerDots,
  );

  return listOfPlayerDots;
}

void _fillDotsForPlayers({
  Map<String, ParticipantProgress> participantsProgress,
  DotModel firstDot,
  int currentMonth,
  List<List<DotModel>> listOfPlayerDots,
}) {
  participantsProgress.forEach((userId, progress) {
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
      }
    });

    listOfPlayerDots.add(dots);
  });
}

void _fillDotsForOptimal({
  int gameTarget,
  DotModel firstDot,
  int currentMonth,
  int initialCash,
  int monthLimit,
  List<List<DotModel>> dotsList,
}) {
  final gameDifference = gameTarget - initialCash;
  final optimalStep = gameDifference ~/ monthLimit;
  final optimalPathDots = <DotModel>[];
  optimalPathDots.add(firstDot);

  for (var monthIndex = 0; monthIndex < currentMonth; monthIndex++) {
    final differenceFromStart = (monthIndex + 1) * optimalStep;
    final optimalCashValue = initialCash + differenceFromStart;

    final dot = DotModel(
      xValue: monthIndex + 1,
      yValue: optimalCashValue,
    );
    optimalPathDots.add(dot);
  }

  dotsList.add(optimalPathDots);
}

List<Series> useGraphicSeries(List<List<DotModel>> dotModels) {
  var graphicId = 0;

  final palettes = MaterialPalette.getOrderedPalettes(dotModels.length);
  final palettesIterator = palettes.iterator;
  palettesIterator.moveNext();

  final series = dotModels.map((subListDots) {
    final palette = palettesIterator.current;
    palettesIterator.moveNext();

    graphicId++;

    return Series<DotModel, int>(
      id: graphicId.toString(),
      colorFn: (_, __) => palette.shadeDefault,
      domainFn: (model, _) => model.xValue,
      measureFn: (model, _) => model.yValue,
      data: subListDots,
    );
  }).toList();

  return series;
}
