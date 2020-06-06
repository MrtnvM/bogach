import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/ui/insurance_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InsuranceGameEvent extends HookWidget {
  const InsuranceGameEvent(this.event);

  final GameEvent event;

  StockEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useInsurancePlayerActionHandler(event.id);
    final infoTableData = useInsuranceInfoTableData(event);

    return Column(
      children: <Widget>[
        InfoTable(
          title: event.name,
          titleValue: event.description,
          rows: <Widget>[
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
        ),
        const SizedBox(height: 28),
        PlayerActionBar(confirm: sendPlayerAction),
      ],
    );
  }
}
