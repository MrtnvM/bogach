import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:cash_flow/widgets/containers/game_event_selector/game_event_selector_hook.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:cash_flow/widgets/game_event/game_event_value_selector.dart';
import 'package:cash_flow/widgets/game_event/price_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnPlayerActionParamsChanged = void Function(
  BuySellAction action,
  int selectedCount,
);

class GameEventSelector extends HookWidget {
  const GameEventSelector({
    Key key,
    @required this.viewModel,
    @required this.onPlayerActionParamsChanged,
  })  : assert(viewModel != null),
        assert(onPlayerActionParamsChanged != null),
        super(key: key);

  final SelectorViewModel viewModel;
  final OnPlayerActionParamsChanged onPlayerActionParamsChanged;

  @override
  Widget build(BuildContext context) {
    final _selectedCount = useState(1);
    final _buySellAction = useState(const BuySellAction.buy());

    final selectorStateModel = normalizeSelectorState(
      currentAction: _buySellAction.value,
      selectedCount: _selectedCount.value,
      availableCash: viewModel.availableCash,
      maxCountToBuy: viewModel.maxCount,
      currentPrice: viewModel.currentPrice,
      alreadyHave: viewModel.alreadyHave,
    );

    _selectedCount.value = selectorStateModel.selectedCount;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (viewModel.changeableType)
            BuySellBar(
              selectedAction: _buySellAction.value,
              onActionChanged: (action) {
                _selectedCount.value = 1;
                _buySellAction.value = action;
                onPlayerActionParamsChanged(action, _selectedCount.value);
              },
              canSell: selectorStateModel.canSell,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: <Widget>[
                PriceCalculator(
                  count: selectorStateModel.selectedCount,
                  currentPrice: viewModel.currentPrice.toDouble(),
                  onCountChanged: (count) {
                    _selectedCount.value = count;
                    onPlayerActionParamsChanged(_buySellAction.value, count);
                  },
                ),
                GameEventValueSelector(
                  action: _buySellAction.value,
                  selectedCount: selectorStateModel.selectedCount,
                  availableCount: selectorStateModel.availableCount,
                  maxCount: selectorStateModel.maxCount,
                  minCount: selectorStateModel.minCount,
                  onCountChanged: (count) {
                    _selectedCount.value = count;
                    onPlayerActionParamsChanged(_buySellAction.value, count);
                  },
                  isChangeableType: viewModel.changeableType,
                  passiveIncomePerMonth: viewModel.passiveIncomePerMonth.toDouble(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectorViewModel {
  const SelectorViewModel({
    this.currentPrice,
    this.passiveIncomePerMonth = 0,
    this.alreadyHave,
    this.maxCount,
    this.changeableType = true,
    this.availableCash,
  });

  final double currentPrice;
  final double passiveIncomePerMonth;
  final int alreadyHave;
  final int maxCount;
  final bool changeableType;
  final double availableCash;
}
