import 'package:flutter_platform_network/flutter_platform_network.dart';

class RequestCommonErrorException implements Exception {
  const RequestCommonErrorException(this.response);

  final Response response;

  @override
  String toString() {
    return 'Request error: ${response?.toString()}';
  }
}
