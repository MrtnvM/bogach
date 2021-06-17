import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/models/insurance_event_data.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'insurance_game_event_hooks.dart';

class InsuranceActionBar extends HookWidget {
  const InsuranceActionBar({Key? key, required this.event}) : super(key: key);

  final GameEvent event;

  InsuranceEventData get eventData => event.data as InsuranceEventData;

  @override
  Widget build(BuildContext context) {
    final sendPlayerAction = useInsurancePlayerActionHandler(event);
    final skipPlayerAction = useSkipAction(event.id);

    return PlayerActionBar(
      confirm: () {
        sendPlayerAction();
        AnalyticsSender.buyInsurance(
          event.name,
          eventData.cost,
        );
      },
      skip: () {
        skipPlayerAction();

        AnalyticsSender.skipBuyInsurance(
          event.name,
          eventData.cost,
        );
      },
    );
  }
}
