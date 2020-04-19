import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/cupertino.dart';

const Color _defaultTextColor = ColorRes.white;

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

  static const caption = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: _defaultTextColor,
  );

  static const overline = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: _defaultTextColor,
  );

  static const error = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.6,
    color: ColorRes.errorRed,
  );
}
