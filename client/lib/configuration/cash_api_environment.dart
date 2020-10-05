import 'package:flutter/foundation.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

class CashApiEnvironment extends ApiEnvironment {
  const CashApiEnvironment({
    @required String baseUrl,
    @required this.name,
    bool validateRequestsByDefault = true,
    bool isRequestsAuthorisedByDefault = false,
    this.isAnalyticsEnabled = false,
    this.isLoggerEnabled = false,
  }) : super(
          baseUrl: baseUrl,
          validateRequestsByDefaut: validateRequestsByDefault,
          isRequestsAuthorisedByDefault: isRequestsAuthorisedByDefault,
        );

  final String name;
  final bool isAnalyticsEnabled;
  final bool isLoggerEnabled;

  static const development = CashApiEnvironment(
    name: 'development',
    baseUrl: 'http://localhost:5001/cash-flow-uat/europe-west2/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: false,
    isLoggerEnabled: true,
  );

  static const staging = CashApiEnvironment(
    name: 'staging',
    baseUrl: 'https://europe-west2-cash-flow-staging.cloudfunctions.net/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: false,
    isLoggerEnabled: true,
  );

  static const uat = CashApiEnvironment(
    name: 'uat',
    baseUrl: 'https://europe-west2-cash-flow-uat.cloudfunctions.net/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: true,
  );

  static const production = CashApiEnvironment(
    name: 'production',
    baseUrl: 'https://europe-west2-bogach-production.cloudfunctions.net/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
    isAnalyticsEnabled: true,
    isLoggerEnabled: false,
  );
}
