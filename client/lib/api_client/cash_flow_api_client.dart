library cash_flow_api;

import 'package:cash_flow/api_client/headers.dart';
import 'package:cash_flow/models/network/responses/game_template_response_model.dart';
import 'package:cash_flow/api_client/response_mappers.dart' as response_mappers;
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';

class CashFlowApiClient extends ApiClient {
  CashFlowApiClient({
    @required ApiEnvironment environment,
    @required Dio dio,
  }) : super(environment: environment, dio: dio);

  Stream<List<GameTemplateResponseModel>> getGameTemplates() => get(
        path: 'v1/account/shifts',
        // ignore: avoid_as
        responseMapper: response_mappers.standard((json) => (json as List)
            .map((item) => GameTemplateResponseModel.fromJson(item))
            .toList()),
        headers: [contentJson],
        isAuthorisedRequest: false,
      );
}
