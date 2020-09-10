import 'package:flutter/foundation.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

class CashApiEnvironment extends ApiEnvironment {
  const CashApiEnvironment({
    @required String baseUrl,
    @required this.name,
    bool validateRequestsByDefault = true,
    bool isRequestsAuthorisedByDefault = false,
  }) : super(
          baseUrl: baseUrl,
          validateRequestsByDefaut: validateRequestsByDefault,
          isRequestsAuthorisedByDefault: isRequestsAuthorisedByDefault,
        );

  final String name;

  static const development = CashApiEnvironment(
    name: 'development',
    baseUrl: 'http://localhost:5001/cash-flow-uat/europe-west2/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
  );

  static const staging = CashApiEnvironment(
    name: 'staging',
    baseUrl: 'https://europe-west2-cash-flow-staging.cloudfunctions.net/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
  );

  static const uat = CashApiEnvironment(
    name: 'uat',
    baseUrl: 'https://europe-west2-cash-flow-uat.cloudfunctions.net/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
  );

  static const production = CashApiEnvironment(
    name: 'production',
    baseUrl: 'https://europe-west2-bogach-production.cloudfunctions.net/',
    validateRequestsByDefault: false,
    isRequestsAuthorisedByDefault: false,
  );
}
