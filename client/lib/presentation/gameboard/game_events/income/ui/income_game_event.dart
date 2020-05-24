import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/ui/income_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class IncomeGameEvent extends HookWidget {
  const IncomeGameEvent(this.event);

  final GameEvent event;

  StockEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useIncomePlayerActionHandler(event: event);

    return Column(
      children: <Widget>[
        Text(event.name, style: Styles.tableHeaderTitle),
        const SizedBox(height: 16),
        Text(event.description, style: Styles.tableHeaderValue),
        const SizedBox(height: 24),
        const SizedBox(height: 28),
        PlayerActionBar(confirm: sendPlayerAction),
      ],
    );
  }
}
