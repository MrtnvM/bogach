import 'dart:math';

import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationBar extends HookWidget {
  const NavigationBar({
    required this.opacity,
    Key? key,
    this.title,
    this.subtitle,
    this.goBack,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final VoidCallback? goBack;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final notchSize = useNotchSize();

    return Opacity(
      opacity: max(min(opacity, 1), 0),
      child: Container(
        margin: EdgeInsets.only(top: notchSize.top + 6),
        constraints: const BoxConstraints.expand(height: 50),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildBackButton(),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: goBack ?? appRouter.goBack,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SvgPicture.asset(Images.icBack),
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
            if (title?.isNotEmpty ?? false)
              Text(title!, style: Styles.navBarTitle),
            if (subtitle?.isNotEmpty ?? false) ...[
              const SizedBox(height: 10),
              Text(subtitle!, style: Styles.navBarSubtitle),
            ]
          ],
        ),
      ),
    );
  }
}
