import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: avoid_classes_with_only_static_members
class AppConfiguration {
  static CashApiEnvironment? _environment;

  static CashApiEnvironment? get environment => _environment;

  static bool get initializationWasCalled => environment != null;

  // ignore: use_setters_to_change_properties
  static Future<void> init({required CashApiEnvironment environment}) async {
    assert(!initializationWasCalled, 'Init should be called once!');

    _environment = environment;
    print('Environment: ${_environment!.name}');

    _checkIsCorrectFirebaseEnvironmentSelected();
  }

  static bool get controlPanelEnabled =>
      _environment != CashApiEnvironment.production;

  static void _checkIsCorrectFirebaseEnvironmentSelected() {
    final options = Firebase.app().options;

    if (environment == CashApiEnvironment.development) {
      assert(options.projectId.contains('staging'));
      return;
    }

    switch (environment) {
      case CashApiEnvironment.staging:
        assert(options.projectId.contains('staging'));
        break;

      case CashApiEnvironment.uat:
        assert(options.projectId.contains('uat'));
        break;

      case CashApiEnvironment.production:
        assert(options.projectId.contains('production'));
        break;
    }
  }
}
