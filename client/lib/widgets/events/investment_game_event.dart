import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/inputs/border_input_field.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InvestmentGameEvent extends StatefulWidget {
  const InvestmentGameEvent(this.viewModel);

  final InvestmentViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return InvestmentGameEventState();
  }
}

class InvestmentGameEventState extends State<InvestmentGameEvent> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: ColorRes.grey,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.home,
                color: ColorRes.white,
              ),
              const SizedBox(width: 12),
              Text(
                Strings.investments.toUpperCase(),
                style: Styles.subhead.copyWith(color: ColorRes.white),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: Strings.currentPrice, style: Styles.body1),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 4,
                      ),
                    ),
                    TextSpan(
                        text: widget.viewModel.currentPrice.toPrice(),
                        style: Styles.body2.copyWith(color: ColorRes.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildInfo(widget.viewModel),
            ],
          ),
        ),
        _buildTabBar(),
        Container(
          color: ColorRes.grey2,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              _builtInputField(widget.viewModel),
              _state == InvestmentState.purchasing
                  ? _buildPurchaseSelector(widget.viewModel)
                  : _buildSellingSelector(widget.viewModel),
            ],
          ),
        ),
        _buildButtons(),
      ],
    );
  }

  Widget _buildInfo(InvestmentViewModel viewModel) {
    final map = {
      Strings.investmentType: viewModel.type,
      Strings.nominalCost: viewModel.nominalCost.toPrice(),
      Strings.passiveIncomePerMonth: viewModel.passiveIncomePerMonth.toPrice(),
      Strings.roi: viewModel.roi.toPercent(),
      Strings.alreadyHave: viewModel.alreadyHave == 0
          ? viewModel.alreadyHave.toString()
          : Strings.getUserAvailableCount(
              viewModel.alreadyHave.toString(),
              viewModel.currentPrice.toPrice(),
            ),
    };

    return Column(
      children: map.keys
          .map(
            (key) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[Text(key), const Spacer(), Text(map[key])],
                ),
                Divider(
                  height: 0,
                  color: ColorRes.black,
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ActionButton(
          onPressed: () {},
          color: ColorRes.orange,
          text: Strings.takeLoan,
        ),
        const SizedBox(width: 6),
        ActionButton(
          onPressed: () {},
          color: ColorRes.green,
          text: Strings.confirm,
        ),
        const SizedBox(width: 6),
        ActionButton(
          onPressed: () {},
          color: Colors.grey,
          text: Strings.skip,
        ),
      ],
    );
  }

  Widget _buildPurchaseSelector(InvestmentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
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
        ),
        _buildIncomePerMonth(viewModel),
        _buildBuyButtons(viewModel),
      ],
    );
  }

  void _onCountChanged(double value) {
    setState(() {
      final convertedValue = value.toInt();

      _countController.text = convertedValue.toString();
      _selectedCount = convertedValue;
    });
  }

  Widget _buildIncomePerMonth(InvestmentViewModel viewModel) {
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

  Widget _buildBuyButtons(InvestmentViewModel viewModel) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSelectAllButton(viewModel)),
        Expanded(child: _buildBuyAvailableButton(viewModel)),
        const Spacer(),
      ],
    );
  }

  void _onSelectAllClicked(int selectedCount) {
    setState(() {
      _selectedCount = selectedCount;
    });
  }

  Widget _buildSelectAllButton(InvestmentViewModel viewModel) {
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

  Widget _buildBuyAvailableButton(InvestmentViewModel viewModel) {
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

  void _onBuyAllAvailableClicked(InvestmentViewModel viewModel) {
    setState(() {
      // TODO(Artem): change this when user balance  will be avaible
      _selectedCount = 0;
    });
  }

  Widget _buildSellingSelector(InvestmentViewModel viewModel) {
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
        _buildSpendingPerMonth(viewModel),
        _buildSellButtons(viewModel),
      ],
    );
  }

  Widget _buildSpendingPerMonth(InvestmentViewModel viewModel) {
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

  Widget _buildSellButtons(InvestmentViewModel viewModel) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildSellAllButton(viewModel)),
        Expanded(child: _buildSellAvailableButton(viewModel)),
        const Spacer(),
      ],
    );
  }

  Widget _buildSellAllButton(InvestmentViewModel viewModel) {
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

  Widget _buildSellAvailableButton(InvestmentViewModel viewModel) {
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

  void _onSellAllAvailableClicked(InvestmentViewModel viewModel) {
    setState(() {
      _selectedCount = viewModel.alreadyHave;
    });
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

  Widget _builtInputField(InvestmentViewModel viewModel) {
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
}

class InvestmentViewModel {
  const InvestmentViewModel({
    this.currentPrice,
    this.type,
    this.nominalCost,
    this.passiveIncomePerMonth,
    this.roi,
    this.alreadyHave,
    this.maxCount,
  });

  final int currentPrice;
  final String type;
  final int nominalCost;
  final int passiveIncomePerMonth;
  final double roi;
  final int alreadyHave;
  final int maxCount;
}

enum InvestmentState {
  purchasing,
  selling,
}
