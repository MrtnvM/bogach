import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:cash_flow/widgets/game_event/game_event_value_selector.dart';
import 'package:cash_flow/widgets/game_event/price_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnPlayerActionParamsChanged = void Function(
  BuySellAction action,
  int selectedCount,
);

class GameEventSelector extends StatefulWidget {
  const GameEventSelector({
    @required this.viewModel,
    @required this.onPlayerActionParamsChanged,
  })  : assert(viewModel != null),
        assert(onPlayerActionParamsChanged != null);

  final SelectorViewModel viewModel;
  final OnPlayerActionParamsChanged onPlayerActionParamsChanged;

  @override
  State<StatefulWidget> createState() {
    return GameEventSelectorState();
  }
}

class GameEventSelectorState extends State<GameEventSelector> {
  var _selectedCount = 0;
  var _buySellAction = const BuySellAction.buy();

  SelectorViewModel get vm => widget.viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.grey2,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (vm.changeableType)
            BuySellBar(
              selectedAction: _buySellAction,
              onActionChanged: _changeState,
            ),
          const SizedBox(height: 12),
          PriceCalculator(
            count: _selectedCount,
            currentPrice: vm.currentPrice.toDouble(),
            onCountChanged: _onCountInputFieldChanged,
          ),
          GameEventValueSelector(
            action: _buySellAction,
            selectedCount: _selectedCount,
            availableCount: 0, // vm.maxCount,
            maxCount: vm.maxCount,
            onCountChanged: _onSelectedCountChanged,
            isChangeableType: vm.changeableType,
            passiveIncomePerMonth: vm.passiveIncomePerMonth.toDouble(),
          ),
        ],
      ),
    );
  }

  void _onSelectedCountChanged(int count) {
    setState(() {
      _selectedCount = count;
    });

    widget.onPlayerActionParamsChanged(_buySellAction, count);
  }

  void _changeState(BuySellAction action) {
    const selectedCount = 0;

    setState(() {
      _buySellAction = action;
      _selectedCount = selectedCount;
    });

    widget.onPlayerActionParamsChanged(action, selectedCount);
  }

  void _onCountInputFieldChanged(int count) {
    final maxCount = widget.viewModel.maxCount;

    setState(() {
      _selectedCount = count > maxCount ? maxCount : count;
    });

    widget.onPlayerActionParamsChanged(_buySellAction, count);
  }
}

class SelectorViewModel {
  const SelectorViewModel({
    this.currentPrice,
    this.passiveIncomePerMonth = 0,
    this.alreadyHave,
    this.maxCount,
    this.changeableType = true,
  });

  final int currentPrice;
  final int passiveIncomePerMonth;
  final int alreadyHave;
  final int maxCount;
  final bool changeableType;
}
