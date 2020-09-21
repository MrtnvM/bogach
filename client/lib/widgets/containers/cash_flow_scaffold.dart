import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/widgets/avatar/user_widget.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:cash_flow/widgets/texts/title_test.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:flutter_svg/svg.dart';

class CashFlowScaffold extends StatelessWidget {
  const CashFlowScaffold({
    @required this.child,
    @required this.title,
    Key key,
    this.showUser = false,
    this.footerImage,
    this.horizontalPadding = 32,
    this.showBackArrow = false,
  }) : super(key: key);

  final Widget child;
  final bool showUser;
  final String title;
  final String footerImage;
  final double horizontalPadding;
  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    return DropFocus(
      child: Scaffold(
        backgroundColor: ColorRes.mainGreen,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildHeader(),
                    const SizedBox(height: 24),
                  ],
                ),
                if (footerImage == null)
                  Expanded(child: child)
                else ...[
                  child,
                  _buildFooterImage(),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (showBackArrow)
                Container(
                  padding: const EdgeInsets.only(left: 4),
                  child: IconButton(
                    onPressed: appRouter.goBack,
                    icon: SvgPicture.asset(
                      Images.icBackWhite,
                      width: 24,
                      height: 12,
                    ),
                  ),
                )
              else
                Container(),
              showUser ? UserWidget() : Container(),
              if (showBackArrow) const SizedBox(width: 56) else Container(),
            ],
          ),
          TitleText(title),
        ],
      ),
    );
  }

  Widget _buildFooterImage() {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 220),
        alignment: Alignment.bottomCenter,
        child: ControlPanelGate(
          isEnabled: AppConfiguration.controlPanelEnabled,
          child: Center(
            child: Image.asset(
              footerImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
