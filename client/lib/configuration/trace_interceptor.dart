import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:cash_flow/utils/performace_utils.dart';

class TraceInterceptor extends Interceptor {
  final Map<String, HttpMetric> traces = {};

  @override
  Future onRequest(RequestOptions options) {
    _startTracing(options);
    return super.onRequest(options);
  }

  @override
  Future onError(DioError err) {
    _stopTracing(err.response);
    return super.onError(err);
  }

  @override
  Future onResponse(Response response) {
    _stopTracing(response);
    return super.onResponse(response);
  }

  void _stopTracing(Response response) {
    final path = response.request.fullUrl;
    final metric = traces[path];

    metric
      ..responseContentType = response.headers.value('Content-Type')
      ..httpResponseCode = response.statusCode;
    metric.stop();

    traces.remove(path);
  }

  void _startTracing(RequestOptions options) {
    traces[options.fullUrl] = FirebasePerformance.instance.newHttpMetric(
      options.fullUrl,
      getHttpMethodFromString(options.method),
    );
    traces[options.fullUrl].start();
  }
}

extension RequestOptionsExtension on RequestOptions {
  String get fullUrl => '$baseUrl$path';
}
