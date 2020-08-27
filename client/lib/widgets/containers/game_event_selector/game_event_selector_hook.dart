import 'dart:math';

import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/widgets/containers/game_event_selector/selector_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SelectorStateModel normalizeSelectorState({
  @required BuySellAction currentAction,
  @required int selectedCount,
  @required double availableCash,
  @required int maxCountToBuy,
  @required double currentPrice,
  @required int alreadyHave,
}) {
  assert(maxCountToBuy > 0);
  assert(currentPrice > 0);

  final availableCount = currentAction.when(
    buy: () {
      final total = availableCash != null && availableCash > 0
          ? availableCash ~/ currentPrice
          : 0;
      return min(maxCountToBuy, total);
    },
    sell: () => alreadyHave,
  );

  final maxCount = _getMaxCount(currentAction, maxCountToBuy, alreadyHave);
  final minCount = _getMinCount(currentAction, alreadyHave);
  final normalizedSelectedCount = _getSelectedCount(
    minCount,
    maxCount,
    selectedCount,
  );

  final canSell = alreadyHave > 0;

  return SelectorStateModel(
    availableCount: availableCount,
    maxCount: maxCount,
    minCount: minCount,
    selectedCount: normalizedSelectedCount,
    canSell: canSell,
  );
}

int _getMaxCount(
  BuySellAction currentAction,
  int maxCountToBuy,
  int alreadyHave,
) {
  return currentAction.when(buy: () {
    return maxCountToBuy;
  }, sell: () {
    return alreadyHave;
  });
}

int _getMinCount(BuySellAction currentAction, int alreadyHave) {
  if (currentAction == const BuySellAction.sell() && alreadyHave == 0) {
    return 0;
  } else {
    return 1;
  }
}

int _getSelectedCount(int minCount, int maxCount, int selectedCount) {
  if (minCount > selectedCount) {
    return selectedCount;
  } else if (selectedCount > maxCount) {
    return maxCount;
  } else {
    return selectedCount;
  }
}
