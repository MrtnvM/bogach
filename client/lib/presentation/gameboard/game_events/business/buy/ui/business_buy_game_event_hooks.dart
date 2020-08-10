import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_player_action.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useBusinessBuyInfoTableData(GameEvent event) {
  return useMemoized(() {
    final BusinessBuyEventData eventData = event.data;

    final data = {
      Strings.description: event.description,
      Strings.offeredPrice: eventData.currentPrice.toPrice(),
      Strings.fairPrice: eventData.fairPrice.toPrice(),
      Strings.downPayment: eventData.downPayment.toPrice(),
      Strings.debt: eventData.debt.toPrice(),
      Strings.passiveIncomePerMonth: eventData.passiveIncomePerMonth.toPrice(),
      Strings.roi: eventData.payback.toPercent(),
    };

    return data;
  }, [event]);
}

VoidCallback useBusinessBuyPlayerActionHandler({
  @required GameEvent event,
  @required BuySellAction action,
}) {
  final gameActions = useGameActions();
  final context = useContext();

  return () {
    final playerAction = BusinessBuyPlayerAction(
      const BuySellAction.buy(),
      event.id,
    );

    gameActions
        .sendPlayerAction(playerAction, event.id)
        .catchError((e) => handleError(context: context, exception: e));
  };
}

GameEventInfoDialogModel useBusinessBuyInfoDialogModel() {
  return useMemoized(
    () => GameEventInfoDialogModel(
      title: Strings.businessDialogTitle,
      description: Strings.businessDialogDescription,
      keyPoints: {
        Strings.businessDialogKeyPoint1:
            Strings.businessDialogKeyPointDescription1,
        Strings.businessDialogKeyPoint2:
            Strings.businessDialogKeyPointDescription2,
      },
      riskLevel: Rating.high,
      profitabilityLevel: Rating.high,
      complexityLevel: Rating.high,
    ),
  );
}
