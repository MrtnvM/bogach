import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_game_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BusinessesToSellGameEvent extends HookWidget {
  BusinessesToSellGameEvent(this.event);

  final GameEvent event;
  Tuple<String, bool> checkedItem;

  @override
  Widget build(BuildContext context) {
    final infoTableData = useBusinessToSellData(event);

    // TODO нужен дизайн

    return Column(
      children: _buildBody(infoTableData),
    );
  }

  List<Widget> _buildBody(BusinessesToSellData businessesToSellData) {
    final widgets = <Widget>[];

    for (var i = 0; i < businessesToSellData.businessToSellData.length; i++) {
      final data = businessesToSellData.businessToSellData[i];
      final businessId = businessesToSellData.businessToSell[i].id;
      final isChecked = checkedItem != null && checkedItem.item1 == businessId;
      final table = InfoTable(
        title: Strings.businessSell,
        rows: <Widget>[
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              if (value) {
                checkedItem = Tuple(businessId, true);
                setState(() {});
              }
            },
          ),
          for (final item in data.tableData.entries)
            TitleRow(title: item.key, value: item.value)
        ],
      );

      widgets.add(table);
    }
    return widgets;
  }
}
