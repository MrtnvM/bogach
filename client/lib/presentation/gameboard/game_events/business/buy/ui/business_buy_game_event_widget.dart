import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/ui/business_buy_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_content.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BusinessBuyGameEventWidget extends HookWidget {
  const BusinessBuyGameEventWidget(this.event) : assert(event != null);

  final GameEvent event;
  BusinessBuyEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final buySellAction = useState(const BuySellAction.buy());
    final infoTableData = useBusinessBuyInfoTableData(event);
    final sendPlayerAction = useBusinessBuyPlayerActionHandler(
      event: event,
      action: buySellAction.value,
    );
    final businessDialogInfoModel = useBusinessBuyInfoDialogModel();
    final dispatch = useDispatcher();

    return Column(
      children: <Widget>[
        InfoTable(
          title: Strings.business,
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
        PlayerActionBar(
          confirm: () {
            sendPlayerAction();
            AnalyticsSender.buyBusiness(
              event.name,
              eventData.currentPrice,
            );
          },
          skip: () {
            dispatch(SendPlayerMoveAction(eventId: event.id));

            AnalyticsSender.skipBuyBusiness(
              event.name,
              eventData.currentPrice,
            );
          },
        )
      ],
    );
  }
}
