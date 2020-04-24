import 'package:cash_flow/utils/core/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';

class DevicePreviewSetting extends StatefulWidget
    implements ControlPanelSetting {
  const DevicePreviewSetting({Key key}) : super(key: key);

  @override
  Setting get setting => Setting(
        id: runtimeType.toString(),
        title: 'Device Preview',
      );

  @override
  _DevicePreviewSettingState createState() => _DevicePreviewSettingState();
}

class _DevicePreviewSettingState extends State<DevicePreviewSetting> {
  bool isEnabled;

  @override
  void initState() {
    isEnabled = DevicePreviewMode.isEnabled;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingGroup(
      setting: widget.setting,
      onTap: () => onChanged(!isEnabled),
      child: Container(
        height: 36,
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                'Device Preview mode',
                style: TextStyle(
                  color: Colors.white.withAlpha(240),
                  fontSize: 15,
                ),
              ),
            ),
            const Spacer(),
            Switch(
              value: isEnabled,
              onChanged: onChanged,
              activeTrackColor: Colors.grey,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  void onChanged(bool value) {
    setState(() => isEnabled = value);

    DevicePreviewMode.isEnabled = value;
  }
}
