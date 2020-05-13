import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/ui/stock_game_event_hooks.dart';
import 'package:cash_flow/presentation/new_gameboard/finances_board/info_table.dart';
import 'package:cash_flow/presentation/new_gameboard/finances_board/title_row.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/game_event_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StockGameEvent extends HookWidget {
  const StockGameEvent(this.event);
  final GameEvent event;

  StockEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final buySellAction = useState(const BuySellAction.buy());
    final selectedCount = useState(0);
    final infoTableData = useStockInfoTableData(event);
    final gameActions = useGameActions();
    final sendPlayerAction = useStockPlayerActionHandler(
      event: event,
      selectedCount: selectedCount.value,
      action: buySellAction.value,
    );

    const alreadyHave = 0; // TODO(Maxim): replace with real value

    final selectorViewModel = SelectorViewModel(
      currentPrice: eventData.currentPrice,
      alreadyHave: alreadyHave,
      maxCount: eventData.availableCount,
      changeableType: true,
    );

    return Column(
      children: <Widget>[
        InfoTable(
          title: Strings.stock,
          rows: <Widget>[
            for (var item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
        ),
        const SizedBox(height: 24),
        GameEventSelector(
          viewModel: selectorViewModel,
          onPlayerActionParamsChanged: (action, count) {
            selectedCount.value = count;
            buySellAction.value = action;
          },
        ),
        const SizedBox(height: 28),
        PlayerActionBar(
          confirm: sendPlayerAction,
          skip: gameActions.skipPlayerAction,
        )
      ],
    );
  }
}
