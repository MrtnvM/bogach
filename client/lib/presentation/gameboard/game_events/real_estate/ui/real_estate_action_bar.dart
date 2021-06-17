import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/models/real_estate_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/ui/real_estate_buy_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RealEstateActionBar extends HookWidget {
  const RealEstateActionBar({Key? key, required this.event}) : super(key: key);

  final GameEvent event;

  RealEstateBuyEventData get eventData => event.data as RealEstateBuyEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useRealEstateBuyPlayerActionHandler(event);
    final skipPlayerAction = useSkipAction(event.id);

    return PlayerActionBar(
      buySellAction: const BuySellAction.buy(),
      confirm: () {
        sendPlayerAction();
        AnalyticsSender.buyRealEstate(
          event.name,
          eventData.currentPrice,
        );
      },
      skip: () {
        skipPlayerAction();

        AnalyticsSender.skipBuyRealEstate(
          event.name,
          eventData.currentPrice,
        );
      },
    );
  }
}
