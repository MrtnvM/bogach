import 'package:cash_flow/models/network/request/request_common_error_exception.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';

T Function(Response) standard<T>(T Function(Map<String, dynamic>) mapper) {
  return (response) {
    final statusCode = response.statusCode;
    final isRequestSuccessful = statusCode >= 200 && statusCode < 300;
    final data = response.data;
    final isEmptyString = data is String && data.isEmpty;
    final isJsonResponse = data is Map<String, dynamic>;

    if (isRequestSuccessful) {
      if (isJsonResponse) {
        return mapper(data);
      } else if (isEmptyString) {
        return mapper({});
      }
    }

    throw RequestCommonErrorException(response);
  };
}

T Function(Response) jsonArray<T>(T Function(List<dynamic>) mapper) {
  return (response) {
    final statusCode = response.statusCode;
    final isRequestSuccessful = statusCode >= 200 && statusCode < 300;
    final data = response.data;
    final isEmptyString = data is String && data.isEmpty;
    final isJsonResponse = data is List<dynamic>;

    if (isRequestSuccessful) {
      if (isJsonResponse) {
        return mapper(data);
      } else if (isEmptyString) {
        return mapper([]);
      }
    }

    throw RequestCommonErrorException(response);
  };
}
