import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/debenture/debenture_asset.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_player_action.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useDebentureInfoTableData(GameEvent event) {
  final currentDebenture = useCurrentDebenture(event);
  final alreadyHave = currentDebenture?.count ?? 0;

  final DebentureEventData eventData = event.data;

  final alreadyHaveString = alreadyHave == 0
      ? alreadyHave.toString()
      : Strings.getUserAvailableCount(
          alreadyHave.toString(),
          currentDebenture.averagePrice.toPrice(),
        );

  final currentPrice = eventData.currentPrice;
  final previousPrice = currentDebenture?.averagePrice ?? 0.0;
  final priceChange = previousPrice == null
      ? 0.0
      : ((currentPrice - previousPrice) / previousPrice) * 100;

  final data = {
    Strings.investmentType: event.name,
    Strings.nominalCost: eventData.nominal.toPrice(),
    Strings.currentPrice: eventData.currentPrice.toPrice(),
    Strings.passiveIncomePerMonth:
        (eventData.profitabilityPercent / 12).toPercent(),
    Strings.alreadyHave: alreadyHaveString,
    if (alreadyHave > 0)
      Strings.changeInPortfolio: priceChange.toPercentWithSign()
  };

  return data;
}

VoidCallback useDebenturePlayerActionHandler({
  @required GameEvent event,
  @required int selectedCount,
  @required BuySellAction action,
}) {
  final gameActions = useGameActions();
  final context = useContext();

  return () {
    final playerAction = DebenturePlayerAction(
      action,
      selectedCount,
      event.id,
    );

    gameActions
        .sendPlayerAction(playerAction, event.id)
        .catchError((e) => handleError(context: context, exception: e));
  };
}

DebentureAsset useCurrentDebenture(GameEvent event) {
  final userId = useUserId();
  final currentDebenture = useCurrentGame((g) {
    final theSameDebenture = g.possessionState[userId].assets
        .where((a) => a.type == AssetType.debenture)
        .cast<DebentureAsset>()
        .firstWhere((s) => s.name == event.name, orElse: () => null);

    return theSameDebenture;
  });

  return currentDebenture;
}

GameEventInfoDialogModel useDebentureInfoDialogModel() {
  return useMemoized(
    () => GameEventInfoDialogModel(
      title: Strings.debentureDialogTitle,
      description: Strings.debentureDialogDescription,
      keyPoints: {
        Strings.debentureDialogKeyPoint1:
            Strings.debentureDialogKeyPointDescription1,
        Strings.debentureDialogKeyPoint2:
            Strings.debentureDialogKeyPointDescription2,
      },
      riskLevel: Rating.low,
      profitabilityLevel: Rating.low,
      complexityLevel: Rating.low,
    ),
  );
}
