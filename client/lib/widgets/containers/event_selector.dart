import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/inputs/border_input_field.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameEventSelector extends StatefulWidget {
  const GameEventSelector(this.viewModel) : assert(viewModel != null);

  final SelectorViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return GameEventSelectorState();
  }
}

class GameEventSelectorState extends State<GameEventSelector> {
  final TextEditingController _countController =
      TextEditingController(text: '1');
  int _selectedCount = 0;
  InvestmentState _state = InvestmentState.purchasing;

  @override
  void initState() {
    super.initState();

    _countController.addListener(_onInputFieldChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.grey2,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.viewModel.changeableType) _buildTabBar(),
          const SizedBox(height: 12),
          _builtInputField(widget.viewModel),
          _state == InvestmentState.purchasing
              ? _buildPurchaseSelector(widget.viewModel)
              : _buildSellingSelector(widget.viewModel),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _changeState(InvestmentState.purchasing),
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            color: _state == InvestmentState.purchasing
                ? ColorRes.grey2
                : ColorRes.scaffoldBackground,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(unselectedWidgetColor: ColorRes.green),
                  child: Radio(
                    value: InvestmentState.purchasing,
                    groupValue: _state,
                    onChanged: _changeState,
                    activeColor: ColorRes.green,
                  ),
                ),
                Text(Strings.purchasing),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _changeState(InvestmentState.selling),
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            color: _state == InvestmentState.selling
                ? ColorRes.grey2
                : ColorRes.scaffoldBackground,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(unselectedWidgetColor: ColorRes.orange),
                  child: Radio(
                    value: InvestmentState.selling,
                    groupValue: _state,
                    onChanged: _changeState,
                    activeColor: ColorRes.orange,
                  ),
                ),
                Text(Strings.selling),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _builtInputField(SelectorViewModel viewModel) {
    return Container(
      color: ColorRes.grey2,
      child: Row(
        children: <Widget>[
          Text(
            Strings.inputCount,
            style: Styles.body1,
          ),
          const SizedBox(width: 12),
          Container(
            width: 100,
            child: BorderInputField(
              props: InputFieldProps(
                controller: _countController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: ' = ', style: Styles.body1),
                TextSpan(
                  text: (viewModel.currentPrice * _selectedCount).toPrice(),
                  style: Styles.body2.copyWith(color: ColorRes.orange),
                ),
              ],
            ),
          )
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
          TextSpan(text: Strings.incomePerMonth, style: Styles.body1),
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
          TextSpan(text: Strings.incomePerMonth, style: Styles.body1),
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

  void _changeState(InvestmentState state) {
    setState(() {
      _state = state;
      _selectedCount = 0;
    });
  }

  void _onInputFieldChanged() {
    final count = int.parse(_countController.text);

    setState(() {
      _selectedCount = count > widget.viewModel.maxCount ? 0 : count;
    });
  }

  void _onCountChanged(double value) {
    setState(() {
      final convertedValue = value.toInt();

      _countController.text = convertedValue.toString();
      _selectedCount = convertedValue;
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
