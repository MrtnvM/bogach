import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CashCheckbox extends StatelessWidget {
  const CashCheckbox.text({
    @required this.text,
    this.isChecked,
    this.onChanged,
    this.activeColor = ColorRes.grass,
    this.style = Styles.body1,
  })  : assert(text != null),
        widget = null;

  const CashCheckbox.widget({
    @required this.widget,
    this.isChecked,
    this.onChanged,
    this.activeColor = ColorRes.grass,
    this.style = Styles.body1,
  })  : assert(widget != null),
        text = null;

  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final String text;
  final Widget widget;
  final Color activeColor;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: activeColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Flexible(
          child: GestureDetector(
            onTap: () => onChanged(isChecked),
            child: widget ??
                Text(
                  text,
                  style: style.copyWith(color: ColorRes.black),
                ),
          ),
        ),
      ],
    );
  }
}
