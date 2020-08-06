import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class SecondOnBoardingPage extends StatelessWidget {
  const SecondOnBoardingPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.gameButtonColor,
      alignment: Alignment.center,
      child: const Text('I am the second page!'),
    );
  }
}
