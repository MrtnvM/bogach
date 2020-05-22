import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/business/sell/model/business_sell_player_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Map<String, String> useBusinessSellInfoTableData(GameEvent event) {
  return useMemoized(() {

    final userId = useUserId();
    final assets = useCurrentGame((g) => g.possessionState[userId].assets);

    final businesses = assets.where((asset) => asset.type == AssetType.business);

    final cashAssets = _getAssets<CashAsset>(assets, AssetType.cash);

    final BusinessSellEventData eventData = event.data;

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

VoidCallback useBusinessSellPlayerActionHandler({
  @required GameEvent event,
  @required BuySellAction action,
}) {
  final gameActions = useGameActions();
  final context = useContext();

  return () {
    final playerAction = BusinessSellPlayerAction(
      const BuySellAction.buy(),
      event.id,
    );

    gameActions
        .sendPlayerAction(playerAction, event.id)
        .catchError((e) => handleError(context: context, exception: e));
  };
}
