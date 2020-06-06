import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/models/insurance_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/models/insurance_player_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useInsuranceInfoTableData(GameEvent event) {
  return useMemoized(() {
    final InsuranceEventData eventData = event.data;

    final data = {
      Strings.cost: eventData.cost.toPrice(),
      Strings.insuranceDuration: eventData.duration,
      Strings.insuranceValue: eventData.value.toPrice(),
    };

    return data;
  }, [event]);
}

VoidCallback useInsurancePlayerActionHandler(String eventId) {
  final gameActions = useGameActions();
  final context = useContext();
  return () {
    final action = InsurancePlayerAction(eventId);

    gameActions
        .sendPlayerAction(action, eventId)
        .catchError((e) => handleError(context: context, exception: e));
  };
}
