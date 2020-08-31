import 'package:cash_flow/presentation/onboarding/widgets/onboarding_scaffold.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:flutter/material.dart';

class SecondOnBoardingPage extends StatelessWidget {
  const SecondOnBoardingPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: OnboardingScaffold(
        title: 'Денежный поток',
        subtitle:
            'Используй финансовые инструменты для достижения своих целей. '
            '\nНаучим как это делать',
        image: Images.onboardingCalculator,
      ),
    );
  }
}
