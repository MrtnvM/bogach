import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

typedef OnCountChangedCallback = void Function(int);

class PriceCalculator extends StatelessWidget {
  const PriceCalculator({
    @required this.currentPrice,
    Key key,
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
    return Row(
      children: <Widget>[
        const Text(Strings.inputCount, style: Styles.bodyBlack),
        const SizedBox(width: 12),
        Expanded(child: Text('$count', style: Styles.bodyBlack)),
        RichText(
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
