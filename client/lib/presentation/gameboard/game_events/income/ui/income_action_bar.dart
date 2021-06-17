import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/models/income_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'income_game_event_hooks.dart';

class IncomeActionBar extends HookWidget {
  const IncomeActionBar({Key? key, required this.event}) : super(key: key);

  final GameEvent event;

  IncomeEventData get eventData => event.data as IncomeEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useIncomePlayerActionHandler(event: event);

    return PlayerActionBar(confirm: () {
      sendPlayerAction();
      AnalyticsSender.incomeEvent(event.name, eventData.income);
    });
  }
}
