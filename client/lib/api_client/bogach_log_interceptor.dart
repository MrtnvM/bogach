import 'package:cash_flow/configuration/cash_api_environment.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:flutter/foundation.dart';

/// [BogachLogInterceptor] is used to print logs during network requests.
/// It's better to add [BogachLogInterceptor] to the tail
/// of the interceptor queue, otherwise the changes made
/// in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class BogachLogInterceptor extends Interceptor {
  BogachLogInterceptor({
    @required this.environment,
    this.request = true,
    this.requestHeader = false,
    this.requestBody = true,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.logPrint = print,
  });

  final CashApiEnvironment environment;

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  Future onRequest(RequestOptions options) async {
    logPrint('[REQUEST] ${_getRequestInfo(options)}');

    if (requestHeader) {
      logPrint('Headers:');
      options.headers.forEach((key, v) => _printKV(' $key', v));
    }

    if (requestBody) {
      if (options.data == null) {
        logPrint('No Request Body');
      } else {
        logPrint('Request Body:');
        _printAll(options.data);
      }
    }

    logPrint('');
  }

  @override
  Future onError(DioError err) async {
    if (error) {
      final requestInfo = _getRequestInfo(err.request);
      logPrint('[REQUEST FAILED]: $requestInfo');
      logPrint('ERROR: $err');

      if (err.response != null) {
        logPrint('Response:');
        _printResponse(err.response);
      }

      logPrint('');
    }
  }

  @override
  Future onResponse(Response response) async {
    final requestInfo = _getRequestInfo(response.request);
    final statusCode = response.statusCode;

    logPrint('[RESPONSE ($statusCode)]: $requestInfo');
    _printResponse(response);
  }

  void _printResponse(Response response) {
    if (responseHeader) {
      if (response.isRedirect == true) {
        _printKV('redirect', response.realUri);
      }
      if (response.headers != null) {
        logPrint('headers:');
        response.headers.forEach((key, v) => _printKV(' $key', v.join(',')));
      }
    }

    if (responseBody) {
      final responseData = response.data;

      if (responseData == null ||
          (responseData is String && responseData.trim().isEmpty)) {
        logPrint('No Response Body');
      } else {
        logPrint('Response Data:');
        _printAll(response.toString());
      }
    }

    logPrint('');
  }

  void _printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }

  String _getRequestInfo(RequestOptions options) {
    final envName = environment.name.toUpperCase();
    final method = options.method.toUpperCase();
    final requestPath = '/${options.path}';

    return '$envName $method $requestPath';
  }
}
