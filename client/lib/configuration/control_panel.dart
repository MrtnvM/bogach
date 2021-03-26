import 'package:alice_lightweight/alice.dart';
import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/app/settings_provider.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';

void configureControlPanel(Alice alice, CashFlowApiClient apiClient) {
  final settingsProvider = SettingsProvider(
    alice: alice,
    dios: [apiClient.dio],
  );

  ControlPanel.initialize(
    navigatorKey: appRouter.navigatorKey,
    settingsProvider: settingsProvider,
  );
}
