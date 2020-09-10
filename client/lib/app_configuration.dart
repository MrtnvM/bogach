import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

// ignore: avoid_classes_with_only_static_members
class AppConfiguration {
  static CashApiEnvironment _environment;

  static CashApiEnvironment get environment => _environment;

  static bool get initializationWasCalled => environment != null;

  // ignore: use_setters_to_change_properties
  static Future<void> init({@required CashApiEnvironment environment}) async {
    assert(!initializationWasCalled, 'Init should be called once!');

    _environment = environment ?? await _getEnvironmentFromPackageName();
    print('Environment: ${_environment.name}');

    _checkIsCorrectFirebaseEnvironmentSelected();
  }

  static bool get controlPanelEnabled =>
      _environment != CashApiEnvironment.production;

  static Future<CashApiEnvironment> _getEnvironmentFromPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final package = packageInfo.packageName;

    if (package.contains('uat')) {
      return CashApiEnvironment.uat;
    }

    if (package.contains('staging')) {
      return CashApiEnvironment.staging;
    }

    if (package.contains('development')) {
      return CashApiEnvironment.development;
    }

    return CashApiEnvironment.production;
  }

  static void _checkIsCorrectFirebaseEnvironmentSelected() {
    FirebaseApp.instance.options.then((options) {
      switch (environment) {
        case CashApiEnvironment.development:
          assert(options.projectID.contains('staging'));
          break;

        case CashApiEnvironment.staging:
          assert(options.projectID.contains('staging'));
          break;

        case CashApiEnvironment.uat:
          assert(options.projectID.contains('uat'));
          break;

        case CashApiEnvironment.production:
          assert(options.projectID.contains('production'));
          break;
      }
    });
  }
}
