import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/models/expense_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'expense_game_event_hooks.dart';

class ExpenseGameEvent extends HookWidget {
  const ExpenseGameEvent(this.event);

  final GameEvent event;
  ExpenseEventData get eventData => event.data as ExpenseEventData;

  @override
  Widget build(BuildContext context) {
    final expenseWidgetData = useExpenseEventData(event: event);

    return Column(
      children: <Widget>[
        InfoTable(
          title: expenseWidgetData.eventName,
          subtitle: Strings.expenses,
          image: Images.eventExpense,
          withShadow: false,
          description: expenseWidgetData.eventDescription,
          rows: <Widget>[
            for (final item in expenseWidgetData.data.entries)
              TitleRow(title: item.key, value: item.value)
          ],
        ),
      ],
    );
  }
}
