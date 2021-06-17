import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/ui/business_sell_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/data/selector_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BusinessSellActionBar extends HookWidget {
  const BusinessSellActionBar({
    Key? key,
    required this.event,
    required this.selectorState,
  }) : super(key: key);

  final GameEvent event;
  final ValueNotifier<SelectorState> selectorState;

  BusinessSellEventData get eventData => event.data as BusinessSellEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useBusinessSellPlayerActionHandler(
      event: event,
      businessId: selectorState.value.selectedItemId ?? '',
    );
    final skipPlayerAction = useSkipAction(event.id);

    return PlayerActionBar(
      confirm: () {
        sendPlayerAction();

        AnalyticsSender.sellBusiness(
          event.name,
          eventData.currentPrice,
        );
      },
      skip: () {
        skipPlayerAction();

        AnalyticsSender.skipSellBusiness(
          event.name,
          eventData.currentPrice,
        );
      },
    );
  }
}
