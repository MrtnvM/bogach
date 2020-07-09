import 'package:alice/alice.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:cash_flow/widgets/settings/logout_setting.dart';
import 'package:cash_flow/widgets/uikit/ui_kit_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';

class SettingsProvider extends ControlPanelSettingsProvider {
  SettingsProvider({@required this.alice, @required this.dios}) {
    _configureProxy(dios);
  }

  final Alice alice;
  final List<Dio> dios;

  String _proxyIp;

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
      getToken: Future.value('token'),
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
      const LogoutSetting(),
    ];
  }

  void _configureProxy(List<Dio> dios) {
    for (final dio in dios) {
      final DefaultHttpClientAdapter adapter = dio.httpClientAdapter;

      adapter.onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          return _proxyIp != null ? 'PROXY $_proxyIp:8888' : 'DIRECT';
        };

        client.badCertificateCallback = (cert, host, port) => _proxyIp != null;
      };
    }
  }
}
