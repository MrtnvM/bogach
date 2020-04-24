import 'package:cash_flow/widgets/settings/device_preview_setting_provider.dart';
import 'package:cash_flow/widgets/uikit/ui_kit_setting.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';

class SettingsProvider extends ControlPanelSettingsProvider {
  SettingsProvider();

  @override
  Future<List<ControlPanelSetting>> buildSettings() async {
    final demoProps = DemoSettingProps(
      onDemoModeChanged: (value) {
        print('Demo mode is ${value ? 'enabled' : 'disabled'}');
      },
    );

    final pushProps = PushNotificationsSettingProps(
      getToken: Future.value('token'),
    );

    return [
      VersionSetting(),
      DemoSetting(demoProps),
      PushNotificationsSetting(pushProps),
      const DevicePreviewSetting(),
      const LicenseSetting(),
      const UiKitSetting(),
    ];
  }
}
