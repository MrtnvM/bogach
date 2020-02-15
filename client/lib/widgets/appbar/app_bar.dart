import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';

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
  }) : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));

  final Color backgroundColor;
  final Widget title;
  final bool centerTitle;
  final Widget leading;
  @override
  final Size preferredSize;
  final PreferredSizeWidget bottom;
  final List<Widget> actions;
  final Brightness brightness;
  final double titleSpacing;

  @override
  Widget build(BuildContext context) {
    return ControlPanelGate(
      child: AppBar(
        backgroundColor: backgroundColor,
        title: title,
        centerTitle: centerTitle,
        leading: leading,
        bottom: bottom,
        actions: actions,
        brightness: brightness,
        titleSpacing: titleSpacing,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
