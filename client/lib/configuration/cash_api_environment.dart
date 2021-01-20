import 'dart:io';

import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:flutter/foundation.dart';

class CashApiEnvironment extends ApiEnvironment {
  const CashApiEnvironment({
    @required String baseUrl,
    @required this.name,
    @required this.dynamicLink,
    bool validateRequestsByDefault = true,
    bool isRequestsAuthorisedByDefault = false,
    this.realtimeDatabaseUrl,
    this.firestoreHostUrl,
    this.isAnalyticsEnabled = false,
    this.isLoggerEnabled = false,
  }) : super(
          baseUrl: baseUrl,
          validateRequestsByDefaut: validateRequestsByDefault,
          isRequestsAuthorisedByDefault: isRequestsAuthorisedByDefault,
        );

  final String name;
  final DynamicLinks dynamicLink;
  final String firestoreHostUrl;
  final String realtimeDatabaseUrl;
  final bool isAnalyticsEnabled;
  final bool isLoggerEnabled;

  static final development = CashApiEnvironment(
    name: 'development',
    baseUrl:
        'http://${Platform.isIOS ? 'localhost' : '10.0.2.2'}:5001/cash-flow-staging/europe-west2/',
    dynamicLink: const DynamicLinks('staging.bogach-game.ru'),
    firestoreHostUrl: Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080',
    realtimeDatabaseUrl:
        'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:9000/'
        '?ns=cash-flow-staging',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: true,
  );

  static const staging = CashApiEnvironment(
    name: 'staging',
    baseUrl: 'https://europe-west2-cash-flow-staging.cloudfunctions.net/',
    dynamicLink: DynamicLinks('staging.bogach-game.ru'),
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
    baseUrl: 'https://europe-west2-bogach-production.cloudfunctions.net/',
    dynamicLink: DynamicLinks('bogach-game.ru'),
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: true,
  );
}
