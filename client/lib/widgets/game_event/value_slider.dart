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
    @required this.minCount,
    @required this.maxCount,
    this.onCountChanged,
  }) : super(key: key);

  final BuySellAction currentAction;
  final int selectedCount;
  final int minCount;
  final int maxCount;
  final OnCountChangedCallback onCountChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          minCount.toString(),
          style: Styles.bodyBlack,
        ),
        Expanded(
          child: Slider(
            min: minCount.toDouble(),
            max: maxCount.toDouble(),
            activeColor: ColorRes.mainGreen,
            inactiveColor: ColorRes.lightGreen.withOpacity(0.6),
            value: selectedCount.toDouble(),
            onChanged: (count) => onCountChanged(count.toInt()),
            divisions: _getDivisionsCount(),
          ),
        ),
        Text(
          maxCount.toStringAsFixed(0),
          style: Styles.bodyBlack,
        ),
      ],
    );
  }

  int _getDivisionsCount() {
    final difference = maxCount.toInt() - minCount.toInt();
    return difference > 0 ? difference : 1;
  }
}
