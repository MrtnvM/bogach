import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NavigationBar extends HookWidget {
  const NavigationBar({
    Key key,
    @required this.title,
    this.subtitle,
    this.goBack,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final VoidCallback goBack;

  @override
  Widget build(BuildContext context) {
    final notchSize = useNotchSize();

    return Container(
      margin: EdgeInsets.only(top: notchSize.top),
      constraints: const BoxConstraints.expand(height: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildBackButton(),
          _buildTitle(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: goBack ?? appRouter.goBack,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.arrow_back_ios,
          color: ColorRes.primaryWhiteColor,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(right: 54),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: Styles.body1.copyWith(
                color: ColorRes.primaryYellowColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            if (subtitle?.isNotEmpty ?? false) ...[
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(
                  color: ColorRes.levelColor,
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
