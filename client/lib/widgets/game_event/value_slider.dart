import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

typedef OnCountChangedCallback = void Function(int);

class ValueSlider extends StatelessWidget {
  const ValueSlider({
    Key key,
    @required this.currentAction,
    @required this.selectedCount,
    this.minCount = 0,
    @required this.maxCountToBuy,
    @required this.maxCountToSell,
    this.onCountChanged,
  }) : super(key: key);

  final BuySellAction currentAction;
  final int selectedCount;
  final int minCount;
  final int maxCountToBuy;
  final int maxCountToSell;
  final OnCountChangedCallback onCountChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          _getMinCount().toString(),
          style: Styles.bodyBlack,
        ),
        Expanded(
          child: Slider(
            min: _getMinCount().toDouble(),
            max: _getMaxCount().toDouble(),
            activeColor: ColorRes.mainGreen,
            inactiveColor: ColorRes.lightGreen.withOpacity(0.6),
            value: selectedCount.toDouble(),
            onChanged: (count) => onCountChanged(count.toInt()),
            divisions: _getMaxCount().toInt() - _getMinCount().toInt(),
          ),
        ),
        Text(
          _getMaxCount().toStringAsFixed(0),
          style: Styles.bodyBlack,
        ),
      ],
    );
  }

  int _getMaxCount() {
    if (currentAction == const BuySellAction.buy()) {
      return maxCountToBuy;
    } else if (currentAction == const BuySellAction.sell()) {
      return maxCountToSell;
    } else {
      throw Exception('invalid type of buy sell action');
    }
  }

  int _getMinCount() {
    if (currentAction == const BuySellAction.sell() && maxCountToSell == 0) {
      return 0;
    } else if (currentAction == const BuySellAction.sell()) {
      return 1;
    } else {
      return minCount;
    }
  }
}
