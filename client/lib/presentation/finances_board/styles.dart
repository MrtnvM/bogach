import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class Stylez extends TextStyle {
  final TextStyle normal16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  final TextStyle title = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Montserrat',
  );

  final TextStyle detail = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    color: ColorRes.primaryGreyColor,
  );
}
