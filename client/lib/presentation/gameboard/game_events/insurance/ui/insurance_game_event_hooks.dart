import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/models/insurance_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/models/insurance_player_action.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useInsuranceInfoTableData(GameEvent event) {
  return useMemoized(() {
    final InsuranceEventData eventData = event.data;

    final data = {
      Strings.cost: eventData.cost.toPrice(),
      Strings.insuranceDuration: eventData.duration.toString(),
      Strings.insuranceValue: eventData.value.toPrice(),
    };

    return data;
  }, [event]);
}

VoidCallback useInsurancePlayerActionHandler(GameEvent event) {
  final context = useContext();
  final dispatch = useDispatcher();
  final isEnoughCash = useIsEnoughCashValidator();

  return () {
    final InsuranceEventData eventData = event.data;
    final price = eventData.cost;

    if (!isEnoughCash(price.toDouble())) {
      return;
    }

    final action = InsurancePlayerAction(event.id);

    dispatch(SendPlayerMoveAction(eventId: event.id, playerAction: action))
        .catchError((e) => handleError(context: context, exception: e));
  };
}

GameEventInfoDialogModel useInsuranceInfoDialogModel() {
  return useMemoized(
    () => GameEventInfoDialogModel(
      title: Strings.insuranceDialogTitle,
      description: Strings.insuranceDialogDescription,
      keyPoints: {
        Strings.insuranceDialogKeyPoint1:
            Strings.insuranceDialogKeyPointDescription1,
        Strings.insuranceDialogKeyPoint2:
            Strings.insuranceDialogKeyPointDescription2,
      },
      riskLevel: Rating.low,
      profitabilityLevel: Rating.medium,
      complexityLevel: Rating.medium,
    ),
  );
}
