import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
/*import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:cash_flow/widgets/game_event/game_event_value_selector.dart';
import 'package:cash_flow/widgets/game_event/price_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

VoidCallback normalizeSelectorState({
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
}*/
