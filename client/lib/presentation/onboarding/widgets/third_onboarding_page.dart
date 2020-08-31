import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/onboarding/widgets/onboarding_scaffold.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/material.dart';

class ThirdOnBoardingPage extends StatelessWidget {
  const ThirdOnBoardingPage();

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
        actionWidget: ActionButton(
          text: Strings.start.toUpperCase(),
          onPressed: _onStartPressed,
        ),
      ),
    );

    return Container(
      color: ColorRes.mainGreen,
      child: Column(
        children: <Widget>[
          const Spacer(flex: 2),
          const Text('I am the third page!'),
          const Spacer(flex: 2),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 48),
            width: double.infinity,
            child: ActionButton(
              text: Strings.start.toUpperCase(),
              onPressed: _onStartPressed,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _onStartPressed() {
    appRouter.goTo(const LoginPage());
  }
}
