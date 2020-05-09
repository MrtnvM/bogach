import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/game_event/monthly_income.dart';
import 'package:cash_flow/widgets/game_event/value_slider.dart';
import 'package:flutter/material.dart';

typedef OnCountChangedCallback = void Function(int count);

class GameEventValueSelector extends StatelessWidget {
  const GameEventValueSelector({
    Key key,
    @required this.action,
    @required this.selectedCount,
    @required this.availableCount,
    @required this.maxCount,
    @required this.isChangeableType,
    @required this.onCountChanged,
    this.passiveIncomePerMonth = 0,
  })  : assert(action != null),
        assert(selectedCount != null),
        assert(availableCount != null),
        assert(maxCount != null),
        assert(isChangeableType != null),
        assert(onCountChanged != null),
        super(key: key);

  final BuySellAction action;
  final int selectedCount;
  final int availableCount;
  final int maxCount;
  final double passiveIncomePerMonth;
  final OnCountChangedCallback onCountChanged;
  final bool isChangeableType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ValueSlider(
          selectedCount: selectedCount,
          maxCount: maxCount,
          onCountChanged: onCountChanged,
        ),
        if (isChangeableType)
          MonthlyIncomeWidget(
            action: action,
            assetCount: selectedCount,
            passiveIncomePerMonth: passiveIncomePerMonth,
          ),
        _buildBuySellButtons(),
      ],
    );
  }

  Widget _buildBuySellButtons() {
    return Row(
      children: <Widget>[
        Expanded(child: _buildAvailableButton()),
        Expanded(child: _buildSelectAllButton()),
        const Spacer(),
      ],
    );
  }

  Widget _buildSelectAllButton() {
    final title = action.map(
      buy: (_) => Strings.buyAllAvailable,
      sell: (_) => Strings.sellAllAvailable,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onCountChanged(maxCount),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: Styles.body1.copyWith(
                  decoration: TextDecoration.underline,
                  color: ColorRes.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onCountChanged(availableCount),
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.available,
                style: Styles.body1.copyWith(
                  decoration: TextDecoration.underline,
                  color: ColorRes.blue,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 4)),
              TextSpan(
                text: availableCount.toStringAsFixed(0),
                style: Styles.body1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
