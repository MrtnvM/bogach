import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:cash_flow/widgets/game_event/monthly_income.dart';
import 'package:cash_flow/widgets/game_event/price_calculator.dart';
import 'package:cash_flow/widgets/game_event/value_slider.dart';
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
          _buySellAction == const BuySellAction.buy()
              ? _buildPurchaseSelector()
              : _buildSellingSelector(),
        ],
      ),
    );
  }

  Widget _buildPurchaseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ValueSlider(
          selectedCount: _selectedCount,
          maxCount: vm.maxCount,
          onCountChanged: _onCountChanged,
        ),
        if (vm.changeableType)
          MonthlyIncomeWidget(
            action: const BuySellAction.buy(),
            assetCount: _selectedCount,
            passiveIncomePerMonth: vm.passiveIncomePerMonth.toDouble(),
          ),
        _buildBuyButtons(),
      ],
    );
  }

  Widget _buildBuyButtons() {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSelectAllButton()),
        Expanded(child: _buildBuyAvailableButton()),
        const Spacer(),
      ],
    );
  }

  Widget _buildBuyAvailableButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onBuyAllAvailableClicked(vm),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.buyAllAvailable,
                style: Styles.body1.copyWith(
                    decoration: TextDecoration.underline, color: ColorRes.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onBuyAllAvailableClicked(SelectorViewModel viewModel) {
    setState(() {
      // TODO(Artem): change this when user balance  will be avaible
      _selectedCount = 0;
    });
  }

  Widget _buildSellingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              _selectedCount.toInt().toString(),
              style: Styles.body1,
            ),
            Expanded(
              child: Slider(
                min: 0,
                max: vm.alreadyHave.toDouble(),
                value: _selectedCount.toDouble(),
                onChanged: _onCountChanged,
                divisions: vm.alreadyHave.toInt(),
              ),
            ),
            Text(
              vm.alreadyHave.toStringAsFixed(0),
              style: Styles.body1,
            ),
          ],
        ),
        if (vm.changeableType)
          MonthlyIncomeWidget(
            action: const BuySellAction.sell(),
            assetCount: _selectedCount,
            passiveIncomePerMonth: vm.passiveIncomePerMonth.toDouble(),
          ),
        _buildSellButtons(),
      ],
    );
  }

  Widget _buildSellButtons() {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSellAllButton()),
        Expanded(child: _buildSellAvailableButton()),
        const Spacer(),
      ],
    );
  }

  Widget _buildSellAllButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onSelectAllClicked(vm.alreadyHave),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.available,
                style: Styles.body1.copyWith(
                    decoration: TextDecoration.underline, color: ColorRes.blue),
              ),
              const WidgetSpan(
                  child: SizedBox(
                width: 4,
              )),
              TextSpan(
                text: vm.alreadyHave.toStringAsFixed(0),
                style: Styles.body1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSellAvailableButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onSellAllAvailableClicked(vm),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.sellAllAvailable,
                style: Styles.body1.copyWith(
                    decoration: TextDecoration.underline, color: ColorRes.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSellAllAvailableClicked(vm) {
    setState(() {
      _selectedCount = vm.alreadyHave;
    });
  }

  Widget _buildSelectAllButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onSelectAllClicked(vm.maxCount),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.available,
                style: Styles.body1.copyWith(
                    decoration: TextDecoration.underline, color: ColorRes.blue),
              ),
              const WidgetSpan(
                  child: SizedBox(
                width: 4,
              )),
              TextSpan(
                text: vm.maxCount.toStringAsFixed(0),
                style: Styles.body1,
              ),
            ],
          ),
        ),
      ),
    );
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

  void _onCountChanged(num count) {
    setState(() {
      _selectedCount = count.toInt();
    });
  }

  void _onSelectAllClicked(int selectedCount) {
    setState(() {
      _selectedCount = selectedCount;
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
