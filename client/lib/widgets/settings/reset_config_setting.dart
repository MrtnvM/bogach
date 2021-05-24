import 'package:cash_flow/features/config/actions/reset_config_action.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';

class ResetConfigSetting extends StatefulWidget implements ControlPanelSetting {
  const ResetConfigSetting();

  @override
  _ResetConfigSettingState createState() => _ResetConfigSettingState();

  @override
  Setting get setting => Setting(
        id: runtimeType.toString(),
        title: 'Reset Config',
      );
}

class _ResetConfigSettingState extends State<ResetConfigSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red.withAlpha(240),
        ),
        onPressed: _resetConfig,
        child: FittedBox(
          child: Text(
            'Reset App Config',
            style: TextStyle(
              color: Colors.white.withAlpha(240),
              letterSpacing: 0.4,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  void _resetConfig() {
    context.dispatch(ResetConfigAction()).then((_) {
      const snackBar = SnackBar(content: Text('App config have been reset'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).onError((_, st) {
      const snackBar = SnackBar(content: Text('Reset was failed!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
