import 'package:cash_flow/app/settings_provider.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';

void configureControlPanel() {
  final settingsProvider = SettingsProvider();

  ControlPanel.initialize(
    navigatorKey: appRouter.navigatorKey,
    settingsProvider: settingsProvider,
  );
}
