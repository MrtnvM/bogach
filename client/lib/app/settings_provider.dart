import 'package:alice_lightweight/alice.dart';
import 'package:cash_flow/widgets/settings/logout_setting.dart';
import 'package:cash_flow/widgets/settings/purchases_setting.dart';
import 'package:cash_flow/widgets/settings/reset_config_setting.dart';
import 'package:cash_flow/widgets/uikit/ui_kit_setting.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsProvider extends ControlPanelSettingsProvider {
  SettingsProvider({required this.alice, required this.dios}) {
    _configureProxy(dios);
  }

  final Alice alice;
  final List<Dio> dios;

  String _proxyIp = '';

  @override
  Future<List<ControlPanelSetting>> buildSettings() async {
    final demoProps = DemoSettingProps(
      onDemoModeChanged: (value) {
        print('Demo mode is ${value ? 'enabled' : 'disabled'}');
      },
    );

    final proxyProps = await ProxySettingProps.standart((proxyIpAddress) {
      _proxyIp = proxyIpAddress;
    });

    final pushProps = PushNotificationsSettingProps(
      getToken: FirebaseMessaging.instance.getToken(),
    );

    final networkProps = NetworkSettingProps(
      alice: alice,
    );

    return [
      VersionSetting(),
      DemoSetting(demoProps),
      ProxySetting(proxyProps),
      PushNotificationsSetting(pushProps),
      const DevicePreviewSetting(),
      const LicenseSetting(),
      const UiKitSetting(),
      NetworkSetting(networkProps),
      LogConsoleButton(),
      const LogoutSetting(),
      const PurchasesSetting(),
      const ResetConfigSetting(),
    ];
  }

  void _configureProxy(List<Dio> dios) {
    for (final dio in dios) {
      final adapter = dio.httpClientAdapter as DefaultHttpClientAdapter;

      adapter.onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          return _proxyIp.isNotEmpty ? 'PROXY $_proxyIp:8888' : 'DIRECT';
        };

        client.badCertificateCallback =
            (cert, host, port) => _proxyIp.isNotEmpty;
      };
    }
  }
}
