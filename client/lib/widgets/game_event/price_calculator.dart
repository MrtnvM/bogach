import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

typedef OnCountChangedCallback = void Function(int);

class PriceCalculator extends StatelessWidget {
  const PriceCalculator({
    Key? key,
    required this.currentPrice,
    this.onCountChanged,
    this.count = 1,
    required this.action,
  }) : super(key: key);

  final int count;
  final double currentPrice;
  final OnCountChangedCallback? onCountChanged;
  final BuySellAction action;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Row(
      children: <Widget>[
        const Text(Strings.inputCount, style: Styles.bodyBlack),
        const SizedBox(width: 12),
        Expanded(child: Text('$count', style: Styles.bodyBlack)),
        RichText(
          textScaleFactor: mediaQuery.textScaleFactor,
          text: TextSpan(
            children: [
              const TextSpan(text: ' = ', style: Styles.bodyBlack),
              TextSpan(
                text: (currentPrice * count.toDouble()).toPrice(),
                style: Styles.body2.copyWith(
                  color: ColorRes.mainGreen,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
