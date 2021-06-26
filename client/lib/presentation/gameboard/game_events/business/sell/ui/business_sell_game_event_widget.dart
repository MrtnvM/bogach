import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_items/businesses_to_sell_widget.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/selector_state.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_content.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BusinessSellGameEventWidget extends HookWidget {
  const BusinessSellGameEventWidget(this.event, this.selectorState);

  final GameEvent event;
  final ValueNotifier<SelectorState> selectorState;

  BusinessSellEventData get eventData => event.data as BusinessSellEventData;

  @override
  Widget build(BuildContext context) {
    final checkedBusinessId = useState('');
    final infoTableData = useBusinessSellInfoTableData(event);
    final businessDialogInfoModel = useBusinessSellInfoDialogModel();

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        selectorState.value = SelectorState(
          action: const BuySellAction.sell(),
          count: 1,
          selectedItemId: checkedBusinessId.value,
        );
      });
    }, [checkedBusinessId.value]);

    return Column(
      children: <Widget>[
        InfoTable(
          title: '${Strings.business} - ${event.description}',
          withShadow: false,
          rows: <Widget>[
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
          onInfoClick: () {
            AnalyticsSender.infoButtonClick(businessDialogInfoModel.title);

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      businessDialogInfoModel.title,
                      style: Styles.tableHeaderTitleBlack,
                    ),
                  ),
                  content: GameEventInfoDialogContent(
                    businessDialogInfoModel,
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 28),
        BusinessesDescriptionToSellGameEvent(
          event: event,
          onItemCheck: (businessId) {
            checkedBusinessId.value = businessId;
          },
        ),
      ],
    );
  }
}
