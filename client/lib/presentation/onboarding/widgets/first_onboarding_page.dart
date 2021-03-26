import 'package:cash_flow/presentation/onboarding/widgets/onboarding_scaffold.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';

class FirstOnBoardingPage extends StatelessWidget {
  const FirstOnBoardingPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: OnboardingScaffold(
        title: Strings.onboardingTitle1,
        subtitle: Strings.onboardingDescription1,
        image: Images.onboarding1,
      ),
    );
  }
}
