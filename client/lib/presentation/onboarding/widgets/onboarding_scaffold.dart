import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.image,
    this.actionWidget,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String image;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final imageSize = screenWidth * 0.75;

    return Column(
      children: <Widget>[
        Flexible(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.only(top: 32),
            alignment: Alignment.center,
            child: Container(
              height: imageSize,
              width: imageSize,
              child: Image.asset(image),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: Styles.onboardingTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: Styles.onboardingSubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (actionWidget != null) actionWidget,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
