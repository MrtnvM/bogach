import 'package:cash_flow/presentation/onboarding/widgets/first_onboarding_pag.dart';
import 'package:cash_flow/presentation/onboarding/widgets/second_onboarding_page.dart';
import 'package:cash_flow/presentation/onboarding/widgets/third_onboarding_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage();

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            children: const <Widget>[
              FirstOnBoardingPage(),
              SecondOnBoardingPage(),
              ThirdOnBoardingPage(),
            ],
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SmoothPageIndicator(
                    controller: _controller,
                    // PageController
                    count: 3,
                    effect: const WormEffect(
                      dotColor: ColorRes.white,
                      activeDotColor: ColorRes.yellow,
                    ),
                    // your preferred effect
                    onDotClicked: _controller.jumpToPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
