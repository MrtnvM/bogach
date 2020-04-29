import 'package:cash_flow/utils/debug.dart';
import 'package:alice/alice.dart';
import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';

ApiClient configureApiClient({
  Alice alice,
  ApiEnvironment environment,
}) {
  final apiDio = _createApiDio(alice);

  final client = CashFlowApiClient(
    environment: environment,
    dio: apiDio,
  );

  return client;
}

Dio _createApiDio(Alice alice) {
  final apiDio = Dio();

  apiDio.options.connectTimeout = 30 * 1000;
  apiDio.options.receiveTimeout = 30 * 1000;
  apiDio.options.sendTimeout = 30 * 1000;

  apiDio.interceptors.add(alice.getDioInterceptor());

  if (Debug.isDebugModeEnabled()) {
    apiDio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  return apiDio;
}
