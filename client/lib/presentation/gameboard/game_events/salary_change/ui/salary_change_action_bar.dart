import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/salary_change/models/salary_change_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'salary_change_game_event_hooks.dart';

class SalaryChangeActionBar extends HookWidget {
  const SalaryChangeActionBar({
    Key? key,
    required this.event,
  }) : super(key: key);

  final GameEvent event;

  SalaryChangeEventData get eventData => event.data as SalaryChangeEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useSalaryChangePlayerActionHandler(event: event);

    return PlayerActionBar(
      confirm: () {
        sendPlayerAction();
        AnalyticsSender.monthlyExpense(
          event.name,
          eventData.value.toInt(),
        );
      },
    );
  }
}
