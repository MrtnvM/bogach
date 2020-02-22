import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/cupertino.dart';

const Color _defaultTextColor = ColorRes.black;

class Styles {
  static const TextStyle subhead = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
  );
}
