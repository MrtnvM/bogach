import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/models/real_estate_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/models/real_estate_buy_player_action.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useRealEstateBuyInfoTableData(GameEvent event) {
  return useMemoized(() {
    final RealEstateBuyEventData eventData = event.data;

    final data = {
      Strings.description: event.name,
      Strings.offeredPrice: eventData.currentPrice.toPrice(),
      Strings.fairPrice: eventData.fairPrice.toPrice(),
      Strings.downPayment: eventData.downPayment.toPrice(),
      Strings.debt: eventData.debt.toPrice(),
      Strings.passiveIncomePerMonth: eventData.passiveIncomePerMonth.toPrice(),
      Strings.roi: eventData.payback.toPercent(),
      Strings.sellProbability: eventData.sellProbability.toPercent(),
    };

    return data;
  }, [event]);
}

VoidCallback useRealEstateBuyPlayerActionHandler(GameEvent event) {
  final context = useContext();
  final dispatch = useDispatcher();

  return () {
    final action = RealEstateBuyPlayerAction(event.id);

    dispatch(SendPlayerMoveAction(eventId: event.id, playerAction: action))
        .catchError((e) => handleError(context: context, exception: e));
  };
}

GameEventInfoDialogModel useRealEstateInfoDialogModel() {
  return useMemoized(
    () => GameEventInfoDialogModel(
      title: Strings.realEstateDialogTitle,
      description: Strings.realEstateDialogDescription,
      keyPoints: {
        Strings.realEstateDialogKeyPoint1:
            Strings.realEstateDialogKeyPointDescription1,
        Strings.realEstateDialogKeyPoint2:
            Strings.realEstateDialogKeyPointDescription2,
      },
      riskLevel: Rating.medium,
      profitabilityLevel: Rating.low,
      complexityLevel: Rating.medium,
    ),
  );
}
