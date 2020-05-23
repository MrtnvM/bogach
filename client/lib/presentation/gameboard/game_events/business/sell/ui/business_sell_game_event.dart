import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/businesses_to_sell_widget.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BusinessSellGameEvent extends HookWidget {
  const BusinessSellGameEvent(this.event) : assert(event != null);

  final GameEvent event;
  BusinessBuyEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final buySellAction = useState(const BuySellAction.buy());
    final infoTableData = useBusinessSellInfoTableData(event);
    final gameActions = useGameActions();
    final sendPlayerAction = useBusinessSellPlayerActionHandler(
      event: event,
      action: buySellAction.value,
    );

    return Column(
      children: <Widget>[
        InfoTable(
          title: Strings.business,
          rows: <Widget>[
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
        ),
        const SizedBox(height: 28),
        BusinessesToSellGameEvent(event),
        const SizedBox(height: 28),
        PlayerActionBar(
          confirm: sendPlayerAction,
          skip: () => gameActions.skipPlayerAction(event.id),
        )
      ],
    );
  }
}
