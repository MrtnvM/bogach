import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/onboarding/widgets/onboarding_scaffold.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/material.dart';

class ThirdOnBoardingPage extends StatelessWidget {
  const ThirdOnBoardingPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: OnboardingScaffold(
        title: Strings.onboardingTitle3,
        subtitle: Strings.onboardingDescription3,
        image: Images.onboarding3,
        actionWidget: ActionButton(
          text: '${Strings.start.toUpperCase()} !',
          textStyle: Styles.body1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            fontSize: 15,
          ),
          onPressed: _onStartPressed,
        ),
      ),
    );
  }

  void _onStartPressed() {
    appRouter.startWith(LoginPage());
  }
}
