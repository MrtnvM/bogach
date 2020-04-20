import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:cash_flow/widgets/game_event/game_event_value_selector.dart';
import 'package:cash_flow/widgets/game_event/price_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameEventSelector extends StatefulWidget {
  const GameEventSelector(this.viewModel) : assert(viewModel != null);

  final SelectorViewModel viewModel;

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

  void _onSelectedCountChanged(int selectedCount) {
    setState(() {
      _selectedCount = selectedCount;
    });
  }

  void _changeState(BuySellAction action) {
    setState(() {
      _buySellAction = action;
      _selectedCount = 0;
    });
  }

  void _onCountInputFieldChanged(int count) {
    setState(() {
      _selectedCount = count > widget.viewModel.maxCount ? 0 : count;
    });
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

enum InvestmentState {
  purchasing,
  selling,
}
