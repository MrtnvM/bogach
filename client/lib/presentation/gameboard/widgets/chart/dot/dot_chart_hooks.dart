import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/participant/participant.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:charts_flutter/flutter.dart';

import 'dot_model.dart';

List<List<DotModel>> useDotModels(Game game) {
  final initialCash = game.config.initialCash;

  final listOfPlayerDots = <List<DotModel>>[];
  final currentMonth = game.state.monthNumber;

  final monthLimit = game.config.monthLimit;
  if (monthLimit != null) {
    _fillDotsForOptimal(
      gameTarget: game.target.value.toInt(),
      currentMonth: currentMonth,
      initialCash: initialCash,
      monthLimit: game.config.monthLimit,
      dotsList: listOfPlayerDots,
    );
  }

  _fillDotsForPlayers(
    participants: game.participants,
    initialCash: initialCash,
    currentMonth: currentMonth,
    listOfPlayerDots: listOfPlayerDots,
  );

  return listOfPlayerDots;
}

void _fillDotsForPlayers({
  Map<String, Participant> participants,
  int initialCash,
  int currentMonth,
  List<List<DotModel>> listOfPlayerDots,
}) {
  participants.forEach((userId, participant) {
    final dots = <DotModel>[];

    final firstDot = DotModel(
      userId: userId,
      xValue: 0,
      yValue: initialCash,
    );

    dots.add(firstDot);

    final progress = participant.progress;
    final monthsCount = progress.monthResults.length;
    for (var monthIndex = 0; monthIndex < monthsCount; monthIndex++) {
      final monthResults = progress.monthResults[monthIndex];

      if (currentMonth != monthIndex) {
        final dot = DotModel(
          userId: userId,
          xValue: monthIndex,
          yValue: monthResults.cash.toInt(),
        );
        dots.add(dot);
      }
    }

    listOfPlayerDots.add(dots);
  });
}

void _fillDotsForOptimal({
  int gameTarget,
  int currentMonth,
  int initialCash,
  int monthLimit,
  List<List<DotModel>> dotsList,
}) {
  final firstDot = DotModel(
    userId: null,
    xValue: 0,
    yValue: initialCash,
  );

  final gameDifference = gameTarget - initialCash;
  final optimalStep = gameDifference ~/ monthLimit;
  final optimalPathDots = <DotModel>[];
  optimalPathDots.add(firstDot);

  for (var monthIndex = 0; monthIndex < currentMonth; monthIndex++) {
    final differenceFromStart = (monthIndex + 1) * optimalStep;
    final optimalCashValue = initialCash + differenceFromStart;

    final dot = DotModel(
      userId: null,
      xValue: monthIndex + 1,
      yValue: optimalCashValue,
    );
    optimalPathDots.add(dot);
  }

  dotsList.add(optimalPathDots);
}

List<Series> useGraphicSeries(List<List<DotModel>> dotModels) {
  final palettes = MaterialPalette.getOrderedPalettes(dotModels.length);
  final palettesIterator = palettes.iterator;
  palettesIterator.moveNext();

  final series = dotModels.map((subListDots) {
    final palette = palettesIterator.current;
    palettesIterator.moveNext();

    final graphicId = _getUserName(subListDots.first.userId);

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

String _getUserName(String userId) {
  if (userId == null) {
    return Strings.optimalPath;
  } else {
    final userProfiles = useGlobalState((s) {
      final users = [s.profile.currentUser];
      users.addAll(s.multiplayer.userProfiles.items);
      return users;
    });

    final user = userProfiles.firstWhere(
      (user) => user.id == userId,
      orElse: () => null,
    );

    if (user == null) {
      return 'Игрок';
    } else {
      return user.fullName;
    }
  }
}
