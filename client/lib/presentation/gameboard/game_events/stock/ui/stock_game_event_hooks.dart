import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_player_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

Map<String, String> useStockInfoTableData(GameEvent event) {
  const alreadyHave = 0; // TODO(Maxim): replace with real value

  return useMemoized(() {
    final StockEventData eventData = event.data;

    final data = {
      Strings.investmentType: event.type.typeTitle(),
      Strings.fairPrice: eventData.fairPrice.toPrice(),
      Strings.alreadyHave: alreadyHave == 0
          ? alreadyHave.toString()
          : Strings.getUserAvailableCount(
              alreadyHave.toString(),
              eventData.currentPrice.toPrice(),
            ),
    };

    return data;
  }, [alreadyHave, event]);
}

VoidCallback useStockPlayerActionHandler({
  @required GameEvent event,
  @required int selectedCount,
  @required BuySellAction action,
}) {
  final gameActions = useGameActions();
  final context = useContext();

  return () {
    final playerAction = StockPlayerAction(
      action,
      selectedCount,
      event.id,
    );

    gameActions
        .sendPlayerAction(playerAction, event.id)
        .catchError((e) => handleError(context: context, exception: e));
  };
}
