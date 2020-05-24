import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_game_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BusinessesToSellGameEvent extends HookWidget {
  BusinessesToSellGameEvent(
    this.event,
    this.onItemCheck,
  )   : assert(event != null),
        assert(onItemCheck != null);

  final GameEvent event;
  final void Function(String checkedBusinessId) onItemCheck;

  @override
  Widget build(BuildContext context) {
    final infoTableData = useBusinessToSellData(event);
    final checkedItemId = useState<String>();

    return Column(
      children: _buildBody(infoTableData, checkedItemId),
    );
  }

  List<Widget> _buildBody(
    BusinessesToSellData businessesToSellData,
    ValueNotifier<String> checkedItemId,
  ) {
    final widgets = <Widget>[];

    for (var i = 0; i < businessesToSellData.businessesTableData.length; i++) {
      final businessTableData = businessesToSellData.businessesTableData[i];
      final businessAsset = businessesToSellData.businessesAssets[i];
      final businessId = businessAsset.id;
      final isChecked =
          checkedItemId != null && checkedItemId.value == businessId;

      final businessInfo = Column(
        children: <Widget>[
          Wrap(children: <Widget>[
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                if (value) {
                  checkedItemId.value = businessId;
                  onItemCheck.call(businessId);
                }
              },
            ),
            InfoTable(
              title: Strings.businessSell,
              rows: <Widget>[
                for (final item in businessTableData.tableData.entries)
                  TitleRow(title: item.key, value: item.value)
              ],
            ),
          ])
        ],
      );

      widgets.add(businessInfo);
    }
    return widgets;
  }
}
