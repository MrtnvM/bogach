import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CashAppBar extends StatelessWidget implements PreferredSizeWidget {
  CashAppBar({
    this.backgroundColor = ColorRes.white,
    this.title,
    this.centerTitle = true,
    this.leading,
    this.bottom,
    this.actions,
    this.brightness = Brightness.dark,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.elevation,
  }) : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  factory CashAppBar.withBackButton({required String title}) {
    return CashAppBar(
      title: Text(
        title,
        style: Styles.subhead.copyWith(color: ColorRes.black),
      ),
      centerTitle: true,
      leading: GestureDetector(
        onTap: appRouter.goBack,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              Images.icBack,
            ),
          ],
        ),
      ),
    );
  }

  final Color backgroundColor;
  final Widget? title;
  final bool centerTitle;
  final Widget? leading;
  @override
  final Size preferredSize;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Brightness brightness;
  final double titleSpacing;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: title,
      centerTitle: centerTitle,
      leading: leading,
      bottom: bottom,
      actions: actions,
      brightness: brightness,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: false,
      elevation: elevation,
    );
  }
}
