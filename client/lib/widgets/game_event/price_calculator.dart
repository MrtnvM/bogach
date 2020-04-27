import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

typedef OnCountChangedCallback = void Function(int);

class PriceCalculator extends StatelessWidget {
  const PriceCalculator({
    Key key,
    @required this.currentPrice,
    this.onCountChanged,
    this.count = 1,
  })  : assert(currentPrice != null),
        assert(count != null),
        super(key: key);

  final int count;
  final double currentPrice;
  final OnCountChangedCallback onCountChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.grey2,
      child: Row(
        children: <Widget>[
          const Text(Strings.inputCount, style: Styles.body1),
          const SizedBox(width: 12),
          Expanded(child: Text('$count')),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: ' = ', style: Styles.body1),
                TextSpan(
                  text: (currentPrice * count.toDouble()).toPrice(),
                  style: Styles.body2.copyWith(color: ColorRes.orange),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
