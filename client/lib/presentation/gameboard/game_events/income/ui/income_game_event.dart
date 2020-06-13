import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/models/income_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/ui/income_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class IncomeGameEvent extends HookWidget {
  const IncomeGameEvent(this.event);

  final GameEvent event;

  IncomeEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useIncomePlayerActionHandler(event: event);

    return Column(
      children: <Widget>[
        InfoTable(
          title: event.name,
          description: event.description,
          rows: <Widget>[
            TitleRow(
              title: Strings.sum,
              value: eventData.income.toPrice(),
            ),
          ],
        ),
        const SizedBox(height: 28),
        PlayerActionBar(confirm: sendPlayerAction),
      ],
    );
  }
}
