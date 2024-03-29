import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/business/business_asset.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_player_action.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'business_sell_game_event_data.dart';

Map<String, String?> useBusinessSellInfoTableData(GameEvent event) {
  return useMemoized(() {
    final data = {
      Strings.description: event.description,
    };
    return data;
  }, [event]);
}

BusinessesToSellData useBusinessToSellData(GameEvent event) {
  final userId = useUserId()!;
  final assets = useCurrentGame(
    (g) => g?.participants[userId]?.possessionState.assets,
  );

  return useMemoized(() {
    final eventData = event.data as BusinessSellEventData;

    final businessesToSell = assets
        ?.where((asset) => asset.type == AssetType.business)
        .cast<BusinessAsset>()
        .where((asset) => asset.id == eventData.businessId)
        .toList();

    if (businessesToSell == null || businessesToSell.isEmpty) {
      return BusinessesToSellData(null);
    }

    final businessesToSellData = businessesToSell.map((businessToSell) {
      final businessData = {
        Strings.offeredPrice: eventData.currentPrice.toPrice(),
        Strings.fairPrice: businessToSell.fairPrice.toPrice(),
        Strings.downPayment: businessToSell.downPayment.toPrice(),
        Strings.passiveIncomePerMonth:
            businessToSell.passiveIncomePerMonth.toPrice(),
        Strings.roi: businessToSell.payback.toPercent(),
        Strings.sellProbability: eventData.sellProbability.toPercent(),
      };

      return BusinessToSellTableData(
        businessId: businessToSell.id,
        tableData: businessData,
      );
    }).toList();

    return BusinessesToSellData(businessesToSellData);
  }, [event]);
}

VoidCallback useBusinessSellPlayerActionHandler({
  required GameEvent event,
  required String businessId,
}) {
  final context = useContext();
  final dispatch = useDispatcher();
  final gameContext = useCurrentGameContext();

  return () {
    final playerAction = BusinessSellPlayerAction(
      const BuySellAction.sell(),
      event.id,
      businessId,
    );

    dispatch(SendPlayerMoveAction(
      eventId: event.id,
      playerAction: playerAction,
      gameContext: gameContext,
    )).onError((e, st) => handleError(context: context, exception: e));
  };
}

GameEventInfoDialogModel useBusinessSellInfoDialogModel() {
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
