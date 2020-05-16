import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_player_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/metrics/roi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useDebentureInfoTableData(GameEvent event) {
  const alreadyHave = 0; // TODO(Maxim): replace with real value

  return useMemoized(() {
    final DebentureEventData eventData = event.data;

    final alreadyHaveString = alreadyHave == 0
        ? alreadyHave.toString()
        : Strings.getUserAvailableCount(
            alreadyHave.toString(),
            eventData.currentPrice.toPrice(),
          );

    final data = {
      Strings.investmentType: event.type.typeTitle(),
      Strings.nominalCost: eventData.nominal.toPrice(),
      Strings.passiveIncomePerMonth: eventData.profitabilityPercent.toPrice(),
      Strings.roi: ROI.fromInvestment(eventData).toPercent(),
      Strings.alreadyHave: alreadyHaveString,
    };

    return data;
  }, [alreadyHave, event]);
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
