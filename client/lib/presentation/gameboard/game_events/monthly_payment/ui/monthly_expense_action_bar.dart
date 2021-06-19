import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/monthly_payment/models/monthly_expense_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'monthly_expense_game_event_hooks.dart';

class MonthlyExpenseActionBar extends HookWidget {
  const MonthlyExpenseActionBar({Key? key, required this.event})
      : super(key: key);

  final GameEvent event;

  MonthlyExpenseEventData get eventData =>
      event.data as MonthlyExpenseEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useMonthlyExpensePlayerActionHandler(event: event);

    return PlayerActionBar(confirm: () {
      sendPlayerAction();
      AnalyticsSender.monthlyExpense(
        event.name,
        eventData.monthlyPayment,
      );
    });
  }
}
