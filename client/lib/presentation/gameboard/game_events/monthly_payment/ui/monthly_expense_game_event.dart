import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/monthly_payment/monthly_expense_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'monthly_expense_game_event_hooks.dart';

class MonthlyExpenseEvent extends HookWidget {
  const MonthlyExpenseEvent(this.event);

  final GameEvent event;

  MonthlyExpenseEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useMonthlyExpensePlayerActionHandler(event: event);

    return Column(
      children: <Widget>[
        InfoTable(
          title: event.name,
          description: event.description,
          rows: <Widget>[
            TitleRow(
              title: Strings.monthlyExpenseTitle,
              value: eventData.monthlyPayment.toPrice(),
            ),
          ],
        ),
        const SizedBox(height: 28),
        PlayerActionBar(confirm: sendPlayerAction),
      ],
    );
  }
}
