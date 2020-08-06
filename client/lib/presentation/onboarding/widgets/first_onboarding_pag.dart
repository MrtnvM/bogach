import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class FirstOnBoardingPage extends StatelessWidget {
  const FirstOnBoardingPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.primary,
      alignment: Alignment.center,
      child: const Text('I am the first page!'),
    );
  }
}
