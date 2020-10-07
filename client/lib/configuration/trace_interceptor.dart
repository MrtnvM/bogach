import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:cash_flow/utils/performace_utils.dart';
import 'package:flutter/foundation.dart';

class TraceInterceptor extends Interceptor {
  final Map<String, HttpMetric> traces = {};

  @override
  Future onRequest(RequestOptions options) {
    _startTracing(options);
    return super.onRequest(options);
  }

  @override
  Future onError(DioError err) {
    _stopTracing(request: err.request, response: err.response);
    return super.onError(err);
  }

  @override
  Future onResponse(Response response) {
    _stopTracing(request: response.request, response: response);
    return super.onResponse(response);
  }

  void _stopTracing({@required RequestOptions request, Response response}) {
    if (response == null) {
      return;
    }

    final path = request.fullUrl;
    final metric = traces[path];

    metric
      ..responseContentType = response.headers.value('Content-Type')
      ..httpResponseCode = response.statusCode;

    metric.stop();
    traces.remove(path);
  }

  void _startTracing(RequestOptions options) {
    final metric = FirebasePerformance.instance.newHttpMetric(
      options.fullUrl,
      getHttpMethodFromString(options.method),
    );

    metric.start();
    traces[options.fullUrl] = metric;
  }
}

extension RequestOptionsExtension on RequestOptions {
  String get fullUrl => '$baseUrl$path';
}
