import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/ui/stock_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/selector_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StockActionBar extends HookWidget {
  const StockActionBar({
    Key? key,
    required this.event,
    required this.selectorState,
  }) : super(key: key);

  final GameEvent event;
  final ValueNotifier<SelectorState> selectorState;

  StockEventData get eventData => event.data as StockEventData;

  @override
  Widget build(BuildContext context) {
    final action = selectorState.value.action;
    final count = selectorState.value.count;

    final sendPlayerAction = useStockPlayerActionHandler(
      event: event,
      selectedCount: count,
      action: action,
    );

    final skipPlayerAction = useSkipAction(event.id);

    return PlayerActionBar(
      buySellAction: action,
      count: count,
      confirm: () {
        sendPlayerAction();

        AnalyticsSender.buySellStock(
          action,
          count,
          event.name,
          eventData.currentPrice,
        );
      },
      skip: () {
        skipPlayerAction();

        AnalyticsSender.skipBuySellStock(
          action,
          event.name,
          eventData.currentPrice,
        );
      },
    );
  }
}
