import 'dart:convert';

import 'package:cash_flow/models/errors/domain_game_error.dart';
import 'package:cash_flow/models/network/core/response_model.dart';
import 'package:dash_kit_network/dash_kit_network.dart';

T Function(Response) standard<T>(T Function(Map<String, dynamic>) mapper) {
  return (response) {
    final statusCode = response.statusCode;
    final isRequestSuccessful = statusCode >= 200 && statusCode < 300;
    final data = response.data;
    final isJsonResponse = data is Map<String, dynamic>;

    if (isRequestSuccessful) {
      if (isJsonResponse) {
        return mapper(data);
      } else {
        return mapper({});
      }
    }

    final errorResponseData = json.decode(data);
    final isErrorResponseDataJson = errorResponseData is Map<String, dynamic>;

    if (isErrorResponseDataJson && errorResponseData['type'] == 'domain') {
      throw DomainGameError.fromJson(errorResponseData);
    }

    throw ResponseErrorModel(response);
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

    if (isJsonResponse && data['type'] == 'domain') {
      throw DomainGameError.fromJson(data);
    }

    throw ResponseErrorModel(response);
  };
}

VoidResponseModel voidResponse(Response response) {
  if ([200, 201, 204].contains(response.statusCode)) {
    return VoidResponseModel();
  }

  final data = json.decode(response.data);
  final isJsonResponse = data is Map<String, dynamic>;

  if (isJsonResponse && data['type'] == 'domain') {
    throw DomainGameError.fromJson(data);
  }

  throw ResponseErrorModel(response);
}
