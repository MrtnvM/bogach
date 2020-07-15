import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:flutter/foundation.dart';

// ignore: avoid_classes_with_only_static_members
class AppConfiguration {
  static CashApiEnvironment _environment;

  static CashApiEnvironment get environment => _environment;

  static bool get initializationWasCalled => environment != null;

  // ignore: use_setters_to_change_properties
  static void init({@required CashApiEnvironment environment}) {
    assert(!initializationWasCalled, 'Init should be called once!');
    assert(environment != null, 'Environment can\'t be null');
    _environment = environment;
  }

  static bool get controlPanelEnabled =>
      _environment != CashApiEnvironment.production;
}
