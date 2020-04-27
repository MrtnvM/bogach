import 'package:cash_flow/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';
import 'package:uikit/uikit.dart';

class UiKitSetting extends StatefulWidget implements ControlPanelSetting {
  const UiKitSetting();

  @override
  _UiKitSettingState createState() => _UiKitSettingState();

  @override
  Setting get setting => Setting(
        id: runtimeType.toString(),
        title: 'Ui Kit',
      );
}

class _UiKitSettingState extends State<UiKitSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: RaisedButton(
        color: Colors.green.withAlpha(240),
        child: FittedBox(
          child: Text(
            'UI kit',
            style: TextStyle(
              color: Colors.white.withAlpha(240),
              letterSpacing: 0.4,
              fontSize: 14,
            ),
          ),
        ),
        onPressed: openUiKit,
      ),
    );
  }

  void openUiKit() {
    appRouter.goTo(const UiKitPage(componentWithPadding: true));
  }
}
