import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/ui/business_buy_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BusinessBuyActionBar extends HookWidget {
  const BusinessBuyActionBar({Key? key, required this.event}) : super(key: key);

  final GameEvent event;

  BusinessBuyEventData get eventData => event.data as BusinessBuyEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useBusinessBuyPlayerActionHandler(
      event: event,
      action: const BuySellAction.buy(),
    );
    final skipPlayerAction = useSkipAction(event.id);

    return PlayerActionBar(
      confirm: () {
        sendPlayerAction();
        AnalyticsSender.buyBusiness(
          event.name,
          eventData.currentPrice,
        );
      },
      skip: () {
        skipPlayerAction();

        AnalyticsSender.skipBuyBusiness(
          event.name,
          eventData.currentPrice,
        );
      },
    );
  }
}
