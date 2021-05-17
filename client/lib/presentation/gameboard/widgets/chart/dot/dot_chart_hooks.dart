import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dot_model.dart';

List<LineSeries<DotModel, int>> useSeries(Game game) {
  final monthLimit = game.config.monthLimit;

  return [
    if (monthLimit != null)
      ...buildMonthsCharts(game)
    else
      ...buildParticipantsCharts(game),
  ];
}

Iterable<LineSeries<DotModel, int>> buildParticipantsCharts(Game game) {
  final initialCash = game.config.initialCash;
  final currentMonth = game.state.monthNumber;

  return game.participants.values.map((participant) {
    final dots = <DotModel>[];

    final firstDot = DotModel(
      userId: _getUserName(participant.id),
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
          userId: _getUserName(participant.id),
          xValue: monthIndex,
          yValue: monthResults.cash.toInt(),
        );
        dots.add(dot);
      }
    }

    return LineSeries<DotModel, int>(
      name: _getUserName(participant.id),
      dataSource: dots,
      xValueMapper: (dot, _) => dot.xValue,
      yValueMapper: (dot, _) => dot.yValue,
      // Enable data label
      dataLabelSettings: DataLabelSettings(isVisible: true),
      markerSettings: const MarkerSettings(isVisible: true),
    );
  });
}

Iterable<LineSeries<DotModel, int>> buildMonthsCharts(Game game) {
  final initialCash = game.config.initialCash;
  final monthLimit = game.config.monthLimit!;
  final currentMonth = game.state.monthNumber;
  final gameTarget = game.target.value.toInt();
  final dots = <DotModel>[];

  final firstDot = DotModel(
    userId: null,
    xValue: 0,
    yValue: initialCash,
  );

  final gameDifference = gameTarget - initialCash;
  final optimalStep = gameDifference ~/ monthLimit;
  dots.add(firstDot);

  for (var monthIndex = 0; monthIndex < currentMonth; monthIndex++) {
    final differenceFromStart = (monthIndex + 1) * optimalStep;
    final optimalCashValue = initialCash + differenceFromStart;

    final dot = DotModel(
      userId: null,
      xValue: monthIndex + 1,
      yValue: optimalCashValue,
    );
    dots.add(dot);
  }

  return [
    LineSeries<DotModel, int>(
      name: _getUserName(null),
      dataSource: dots,
      xValueMapper: (dot, _) => dot.xValue,
      yValueMapper: (dot, _) => dot.yValue,
      // Enable data label
      dataLabelSettings: DataLabelSettings(isVisible: true),
    ),
  ];
}

String _getUserName(String? userId) {
  if (userId == null) {
    return Strings.optimalPath;
  } else {
    final userProfiles = useGlobalState((s) {
          final users = [s.profile.currentUser];
          users.addAll(s.multiplayer.userProfiles.items);
          return users;
        }) ??
        [];

    final user = userProfiles.firstWhere(
      (user) => user?.id == userId,
      orElse: () => null,
    );

    if (user == null) {
      return 'Игрок';
    } else {
      return user.fullName;
    }
  }
}
