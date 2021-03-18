import 'package:alice_lightweight/alice.dart';
import 'package:cash_flow/api_client/bogach_log_interceptor.dart';
import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/configuration/trace_interceptor.dart';
import 'package:cash_flow/utils/debug.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

CashFlowApiClient configureApiClient(Alice alice, ApiEnvironment environment) {
  final apiDio = _createApiDio(alice, environment);

  final client = CashFlowApiClient(
    environment: environment,
    dio: apiDio,
  );

  return client;
}

Dio _createApiDio(Alice alice, ApiEnvironment environment) {
  final apiDio = Dio();

  apiDio.options.connectTimeout = 30 * 1000;
  apiDio.options.receiveTimeout = 30 * 1000;
  apiDio.options.sendTimeout = 30 * 1000;

  apiDio.interceptors.add(alice.getDioInterceptor());

  debug(() {
    apiDio.interceptors.add(BogachLogInterceptor(environment: environment));
  });

  apiDio.interceptors.add(TraceInterceptor());

  return apiDio;
}
