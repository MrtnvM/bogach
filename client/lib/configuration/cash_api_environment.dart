import 'dart:io';

import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

class CashApiEnvironment extends ApiEnvironment {
  const CashApiEnvironment({
    required String baseUrl,
    required this.name,
    required this.dynamicLink,
    bool validateRequestsByDefault = true,
    bool isRequestsAuthorisedByDefault = false,
    this.realtimeDatabaseUrl,
    this.firestoreHostUrl,
    this.isAnalyticsEnabled = false,
    this.isLoggerEnabled = false,
  }) : super(
          baseUrl: baseUrl,
          validateRequestsByDefault: validateRequestsByDefault,
          isRequestsAuthorisedByDefault: isRequestsAuthorisedByDefault,
        );

  final String name;
  final DynamicLinks dynamicLink;
  final String? firestoreHostUrl;
  final String? realtimeDatabaseUrl;
  final bool isAnalyticsEnabled;
  final bool isLoggerEnabled;

  static final development = CashApiEnvironment(
    name: 'development',
    baseUrl: 'http://${Platform.isIOS ? 'localhost' : '10.0.2.2'}:5001/',
    dynamicLink: const DynamicLinks('staging.app.bogach-game.ru'),
    firestoreHostUrl: Platform.isAndroid ? '10.0.2.2:8085' : 'localhost:8085',
    realtimeDatabaseUrl:
        'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:9001/'
        '?ns=cash-flow-staging',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: true,
  );

  static const staging = CashApiEnvironment(
    name: 'staging',
    baseUrl: 'https://bogach-staging-api-avmggl2wxa-nw.a.run.app/',
    dynamicLink: DynamicLinks('staging.app.bogach-game.ru'),
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: true,
  );

  static const uat = CashApiEnvironment(
    name: 'uat',
    baseUrl: 'https://europe-west2-cash-flow-uat.cloudfunctions.net/',
    dynamicLink: DynamicLinks('uat.bogach-game.ru'),
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: true,
  );

  static const production = CashApiEnvironment(
    name: 'production',
    baseUrl: 'https://bogach-production-api-rrbvc52dhq-nw.a.run.app/',
    dynamicLink: DynamicLinks('bogach-game.ru'),
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: true,
  );
}
