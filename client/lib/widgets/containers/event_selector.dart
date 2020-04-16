import 'package:cash_flow/models/domain/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:cash_flow/widgets/game_event/price_input_field.dart';
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
  int _selectedCount = 0;
  BuySellAction _buySellAction = const BuySellAction.buy();

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
          if (widget.viewModel.changeableType)
            BuySellBar(onActionChanged: _changeState),
          const SizedBox(height: 12),
          PriceInputField(
            initialCount: _selectedCount,
            currentPrice: vm.currentPrice.toDouble(),
            onCountChanged: _onCountInputFieldChanged,
          ),
          _buySellAction == const BuySellAction.buy()
              ? _buildPurchaseSelector(vm)
              : _buildSellingSelector(vm),
        ],
      ),
    );
  }

  Widget _buildPurchaseSelector(SelectorViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSlider(viewModel),
        if (viewModel.changeableType) _buildIncomePerMonth(viewModel),
        _buildBuyButtons(viewModel),
      ],
    );
  }

  Widget _buildIncomePerMonth(SelectorViewModel viewModel) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: Strings.incomePerMonth, style: Styles.body1),
          const WidgetSpan(
            child: SizedBox(
              width: 6,
            ),
          ),
          TextSpan(
            text: (_selectedCount * viewModel.passiveIncomePerMonth).toPrice(),
            style: Styles.body1.copyWith(color: ColorRes.green),
          )
        ],
      ),
    );
  }

  Widget _buildBuyButtons(SelectorViewModel viewModel) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSelectAllButton(viewModel)),
        Expanded(child: _buildBuyAvailableButton(viewModel)),
        const Spacer(),
      ],
    );
  }

  Widget _buildBuyAvailableButton(SelectorViewModel viewModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onBuyAllAvailableClicked(viewModel),
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

  Widget _buildSellingSelector(SelectorViewModel viewModel) {
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
                max: viewModel.alreadyHave.toDouble(),
                value: _selectedCount.toDouble(),
                onChanged: _onCountChanged,
                divisions: viewModel.alreadyHave.toInt(),
              ),
            ),
            Text(
              viewModel.alreadyHave.toStringAsFixed(0),
              style: Styles.body1,
            ),
          ],
        ),
        if (viewModel.changeableType) _buildSpendingPerMonth(viewModel),
        _buildSellButtons(viewModel),
      ],
    );
  }

  Widget _buildSpendingPerMonth(SelectorViewModel viewModel) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: Strings.incomePerMonth, style: Styles.body1),
          const WidgetSpan(
            child: SizedBox(
              width: 6,
            ),
          ),
          TextSpan(
            text: (-_selectedCount * viewModel.passiveIncomePerMonth).toPrice(),
            style: Styles.body1.copyWith(color: ColorRes.orange),
          )
        ],
      ),
    );
  }

  Widget _buildSellButtons(SelectorViewModel viewModel) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSellAllButton(viewModel)),
        Expanded(child: _buildSellAvailableButton(viewModel)),
        const Spacer(),
      ],
    );
  }

  Widget _buildSellAllButton(SelectorViewModel viewModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onSelectAllClicked(viewModel.alreadyHave),
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
                text: viewModel.alreadyHave.toStringAsFixed(0),
                style: Styles.body1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSellAvailableButton(SelectorViewModel viewModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onSellAllAvailableClicked(viewModel),
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

  void _onSellAllAvailableClicked(SelectorViewModel viewModel) {
    setState(() {
      _selectedCount = viewModel.alreadyHave;
    });
  }

  Widget _buildSelectAllButton(SelectorViewModel viewModel) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onSelectAllClicked(viewModel.maxCount),
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
                text: viewModel.maxCount.toStringAsFixed(0),
                style: Styles.body1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(SelectorViewModel viewModel) {
    return Row(
      children: <Widget>[
        Text(
          _selectedCount.toString(),
          style: Styles.body1,
        ),
        Expanded(
          child: Slider(
            min: 0,
            max: viewModel.maxCount.toDouble(),
            value: _selectedCount.toDouble(),
            onChanged: _onCountChanged,
            divisions: viewModel.maxCount.toInt(),
          ),
        ),
        Text(
          viewModel.maxCount.toStringAsFixed(0),
          style: Styles.body1,
        ),
      ],
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
