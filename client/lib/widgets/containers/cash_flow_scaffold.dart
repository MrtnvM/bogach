import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:cash_flow/widgets/texts/title_test.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CashFlowScaffold extends StatelessWidget {
  const CashFlowScaffold({
    required this.child,
    this.title,
    Key? key,
    this.footerImage,
    this.horizontalPadding = 32,
    this.showBackArrow = false,
    this.backgroundColor = ColorRes.mainGreen,
    this.overlayStyle = SystemUiOverlayStyle.light,
  }) : super(key: key);

  final Widget child;
  final String? title;
  final String? footerImage;
  final double horizontalPadding;
  final bool showBackArrow;
  final Color backgroundColor;
  final SystemUiOverlayStyle overlayStyle;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: DropFocus(
        child: Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (footerImage == null)
                    Expanded(child: child)
                  else ...[
                    Expanded(child: child),
                    _buildFooterImage(context),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return title != null
        ? AppBar(
            title: TitleText(title),
            centerTitle: true,
          )
        : null;
  }

  Widget _buildFooterImage(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight >= 600 ? 200 : 170,
      ),
      margin: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.bottomCenter,
      child: ControlPanelGate(
        isEnabled: AppConfiguration.controlPanelEnabled,
        child: Center(
          child: Image.asset(
            footerImage!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
