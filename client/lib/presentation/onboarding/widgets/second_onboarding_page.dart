import 'package:cash_flow/presentation/onboarding/widgets/onboarding_scaffold.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';

class SecondOnBoardingPage extends StatelessWidget {
  const SecondOnBoardingPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: OnboardingScaffold(
        title: Strings.onboardingTitle2,
        subtitle: Strings.onboardingDescription2,
        image: Images.onboarding2,
      ),
    );
  }
}
