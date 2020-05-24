import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/business/business_asset.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_player_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

import 'business_sell_game_event_data.dart';

Map<String, String> useBusinessSellInfoTableData(GameEvent event) {
  return useMemoized(() {
    final userId = useUserId();
    final assets = useCurrentGame((g) => g.possessionState[userId].assets);

    final BusinessSellEventData eventData = event.data;

    final businessesToSell = assets
        .where((asset) => asset.type == AssetType.business)
        .map((asset) => asset as BusinessAsset)
        .where((asset) => asset.id == eventData.businessId);

    if (businessesToSell == null || businessesToSell.isEmpty) {
      final data = {
        Strings.description: 'sell' + event.description + "но у вас нихуя нет",
      };
      return data;
    } else {
      final data = {
        Strings.description: 'sell' + event.description,
      };

      return data;
    }
  }, [event]);
}

BusinessesToSellData useBusinessToSellData(GameEvent event) {
  return useMemoized(() {
    final userId = useUserId();
    final assets = useCurrentGame((g) => g.possessionState[userId].assets);

    final BusinessSellEventData eventData = event.data;

    final businessesToSell = assets
        .where((asset) => asset.type == AssetType.business)
        .map((asset) => asset as BusinessAsset)
        .where((asset) => asset.id == eventData.businessId)
        .toList();

    if (businessesToSell == null || businessesToSell.isEmpty) {
      return BusinessesToSellData(null, null);
    } else {
      final businessesToSellData = businessesToSell.map((businessToSell) {
        final businessDatadasdsa = {
          Strings.offeredPrice: eventData.currentPrice.toPrice(),
          Strings.fairPrice: businessToSell.fairPrice.toPrice(),
          Strings.downPayment: businessToSell.downPayment.toPrice(),
          Strings.passiveIncomePerMonth:
              businessToSell.passiveIncomePerMonth.toPrice(),
          Strings.roi: businessToSell.payback.toPercent(),
        };

        return BusinessToSellTableData(businessDatadasdsa);
      }).toList();

      return BusinessesToSellData(
        businessesToSell,
        businessesToSellData,
      );
    }
  }, [event]);
}

VoidCallback useBusinessSellPlayerActionHandler({
  @required GameEvent event,
  @required BuySellAction action,
  @required String businessId,
}) {
  final gameActions = useGameActions();
  final context = useContext();

  return () {
    final playerAction = BusinessSellPlayerAction(
      const BuySellAction.buy(),
      event.id,
      businessId,
    );

    gameActions
        .sendPlayerAction(playerAction, event.id)
        .catchError((e) => handleError(context: context, exception: e));
  };
}
