import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/models/expense_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'expense_game_event_hooks.dart';

class ExpenseActionBar extends HookWidget {
  const ExpenseActionBar({Key? key, required this.event}) : super(key: key);

  final GameEvent event;

  ExpenseEventData get eventData => event.data as ExpenseEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useExpensePlayerActionHandler(event: event);

    return PlayerActionBar(
      confirm: () {
        sendPlayerAction();
        AnalyticsSender.expenseEvent(event.name, eventData.expense);
      },
    );
  }
}
