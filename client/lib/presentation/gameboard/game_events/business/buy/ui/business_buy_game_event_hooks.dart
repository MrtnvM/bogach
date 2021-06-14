import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_player_action.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useBusinessBuyInfoTableData(GameEvent event) {
  return useMemoized(() {
    final eventData = event.data as BusinessBuyEventData;

    final data = {
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
  required GameEvent event,
  required BuySellAction action,
}) {
  final dispatch = useDispatcher();
  final context = useContext();
  final isEnoughCash = useIsEnoughCashValidator();
  final gameContext = useCurrentGameContext();

  return () {
    final eventData = event.data as BusinessBuyEventData;
    final price = eventData.currentPrice - eventData.debt;

    if (!isEnoughCash(price.toDouble())) {
      return;
    }

    const inCredit = false;
    final playerAction = BusinessBuyPlayerAction(
      const BuySellAction.buy(),
      event.id,
      inCredit,
    );

    final action = SendPlayerMoveAction(
      eventId: event.id,
      playerAction: playerAction,
      gameContext: gameContext,
    );

    dispatch(action)
        .onError((e, st) => handleError(context: context, exception: e));
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
