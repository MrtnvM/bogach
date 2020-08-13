import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/salary_change/salary_change_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'salary_change_game_event_hooks.dart';

class SalaryChangeEvent extends HookWidget {
  const SalaryChangeEvent(this.event);

  final GameEvent event;

  SalaryChangeEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useSalaryChangePlayerActionHandler(event: event);
    final value = eventData.value;

    return Column(
      children: <Widget>[
        InfoTable(
          title: event.name,
          withShadow: false,
          description: event.description,
          rows: <Widget>[
            TitleRow(
              title: Strings.salaryChangeTitle,
              value: value.toPriceWithSign(),
            ),
          ],
        ),
        const SizedBox(height: 28),
        PlayerActionBar(confirm: () {
          sendPlayerAction();
          AnalyticsSender.sendMonthlyExpenseEvent(
            event.name,
            eventData.value.toInt(),
          );
        }),
      ],
    );
  }
}
