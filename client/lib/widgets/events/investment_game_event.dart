import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestmentGameEvent extends StatefulWidget {
  const InvestmentGameEvent(this.viewModel);

  final InvestmentViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _InvestmentGameEvent();
  }
}

class _InvestmentGameEvent extends State<InvestmentGameEvent> {
  int _selectedCount = 0;
  InvestmentState _state = InvestmentState.purchasing;

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
        _state == InvestmentState.purchasing
            ? _buildPurchaseSelector(widget.viewModel)
            : _buildSellingSelector(widget.viewModel),
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
          onPressed: widget.viewModel.onTakeLoan,
          color: ColorRes.orange,
          text: Strings.takeLoan,
        ),
        const SizedBox(width: 6),
        ActionButton(
          onPressed: widget.viewModel.onConfirm,
          color: ColorRes.green,
          text: Strings.confirm,
        ),
        const SizedBox(width: 6),
        ActionButton(
          onPressed: widget.viewModel.onSkip,
          color: Colors.grey,
          text: Strings.skip,
        ),
      ],
    );
  }

  Widget _buildPurchaseSelector(InvestmentViewModel viewModel) {
    return Container(
      color: ColorRes.grey2,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
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
      ),
    );
  }

  void _onCountChanged(double value) {
    setState(() {
      _selectedCount = value.toInt();
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
    return Container(
      color: ColorRes.grey2,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
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
      ),
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
          onTap: () => setState(() => _state = InvestmentState.purchasing),
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            color: _state == InvestmentState.purchasing
                ? ColorRes.grey2
                : ColorRes.scaffoldBackground,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  value: InvestmentState.purchasing,
                  groupValue: _state,
                  onChanged: (InvestmentState state) {
                    setState(() {
                      _selectedCount = 0;
                      _state = state;
                    });
                  },
                ),
                Text(Strings.purchasing),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _state = InvestmentState.selling),
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            color: _state == InvestmentState.selling
                ? ColorRes.grey2
                : ColorRes.scaffoldBackground,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio(
                  value: InvestmentState.selling,
                  groupValue: _state,
                  onChanged: (InvestmentState state) {
                    setState(() {
                      _selectedCount = 0;
                      _state = state;
                    });
                  },
                ),
                Text(Strings.selling),
              ],
            ),
          ),
        ),
      ],
    );
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
    this.onTakeLoan,
    this.onConfirm,
    this.onSkip,
  });

  final int currentPrice;
  final String type;
  final int nominalCost;
  final int passiveIncomePerMonth;
  final double roi;
  final int alreadyHave;
  final int maxCount;

  final VoidCallback onTakeLoan;
  final VoidCallback onConfirm;
  final VoidCallback onSkip;
}

enum InvestmentState {
  purchasing,
  selling,
}
