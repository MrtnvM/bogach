import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class LogoutSetting extends StatefulWidget implements ControlPanelSetting {
  const LogoutSetting();

  @override
  _LogoutSettingState createState() => _LogoutSettingState();

  @override
  Setting get setting => Setting(
        id: runtimeType.toString(),
        title: 'Log Out',
      );
}

class _LogoutSettingState extends State<LogoutSetting> with ReduxState {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: RaisedButton(
        color: Colors.green.withAlpha(240),
        child: FittedBox(
          child: Text(
            'Log Out',
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
    dispatchAsyncAction(LogoutAsyncAction()).listen((action) =>
        action.onSuccess(_onLogoutFinished)..onError(_onLogoutFinished));
  }

  void _onLogoutFinished(_) {
    appRouter.startWith(const LoginPage());
  }
}
