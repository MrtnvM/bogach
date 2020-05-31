import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/avatar/user_widget.dart';
import 'package:cash_flow/widgets/inputs/drop_focus.dart';
import 'package:cash_flow/widgets/texts/title_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';

class CashFlowScaffold extends StatelessWidget {
  const CashFlowScaffold({
    Key key,
    @required this.child,
    @required this.title,
    this.showUser = false,
    this.footerImage,
    this.horizontalPadding = 32,
  }) : super(key: key);

  final Widget child;
  final bool showUser;
  final String title;
  final String footerImage;
  final double horizontalPadding;

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
          showUser ? UserWidget() : Container(),
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
