import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/material.dart';

class ThirdOnBoardingPage extends StatelessWidget {
  const ThirdOnBoardingPage();

  @override
  Widget build(BuildContext context) {
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
    appRouter.goTo(const MainPage());
  }
}
