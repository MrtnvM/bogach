import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnCountChangedCallback = void Function(int);

class ValueSlider extends HookWidget {
  const ValueSlider({
    @required this.currentPrice,
    @required this.currentAction,
    @required this.selectedCount,
    @required this.minCount,
    @required this.maxCount,
    Key key,
    this.onCountChanged,
  }) : super(key: key);

  final BuySellAction currentAction;
  final double currentPrice;
  final int selectedCount;
  final int minCount;
  final int maxCount;
  final OnCountChangedCallback onCountChanged;

  @override
  Widget build(BuildContext context) {
    final account = useAccount();
    final totalPrice = currentPrice * selectedCount;
    final isEnoughCash = totalPrice <= account.cash;

    final sliderActiveColor = isEnoughCash
        ? ColorRes.mainGreen //
        : ColorRes.primaryYellowColor;
    final sliderInactiveColor = isEnoughCash
        ? ColorRes.lightGreen.withOpacity(0.6)
        : ColorRes.primaryYellowColor.withOpacity(0.4);

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
            activeColor: sliderActiveColor,
            inactiveColor: sliderInactiveColor,
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
