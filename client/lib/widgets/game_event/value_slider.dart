import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class ValueSlider extends StatelessWidget {
  const ValueSlider({
    Key key,
    @required this.selectedCount,
    this.minCount = 0,
    @required this.maxCount,
    this.onCountChanged,
  }) : super(key: key);

  final int selectedCount;
  final int minCount;
  final int maxCount;
  final void Function(int) onCountChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          selectedCount.toString(),
          style: Styles.body1,
        ),
        Expanded(
          child: Slider(
            min: 0,
            max: maxCount.toDouble(),
            value: selectedCount.toDouble(),
            onChanged: (count) => onCountChanged(count.toInt()),
            divisions: maxCount.toInt(),
          ),
        ),
        Text(
          maxCount.toStringAsFixed(0),
          style: Styles.body1,
        ),
      ],
    );
  }
}
