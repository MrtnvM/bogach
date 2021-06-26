import 'package:cash_flow/utils/performace_utils.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:firebase_performance/firebase_performance.dart';

class TraceInterceptor extends Interceptor {
  final Map<String, HttpMetric> traces = {};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _startTracing(options);
    super.onRequest(options, handler);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    _stopTracing(request: err.requestOptions, response: err.response);
    super.onError(err, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _stopTracing(request: response.requestOptions, response: response);
    super.onResponse(response, handler);
  }

  void _stopTracing({required RequestOptions request, Response? response}) {
    if (response == null) {
      return;
    }

    final path = request.fullUrl;
    final metric = traces[path];

    if (metric == null) {
      return;
    }

    metric
      ..responseContentType = response.headers.value('Content-Type')
      ..httpResponseCode = response.statusCode;

    metric.stop();
    traces.remove(path);
  }

  void _startTracing(RequestOptions options) {
    final url = options.fullUrl;

    final metric = FirebasePerformance.instance.newHttpMetric(
      url,
      getHttpMethodFromString(options.method),
    );

    metric.start();
    traces[url] = metric;
  }
}

extension RequestOptionsExtension on RequestOptions {
  String get fullUrl => '$baseUrl$path';
}
