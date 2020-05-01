library cash_flow_api;

import 'package:cash_flow/api_client/headers.dart';
import 'package:cash_flow/models/network/responses/game_template_response_model.dart';
import 'package:cash_flow/api_client/response_mappers.dart' as response_mappers;
import 'package:cash_flow/models/network/responses/new_game_response_model.dart';
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
        path: 'getAllGameTemplates',
        responseMapper: response_mappers.jsonArray((json) => json
            .map((item) => GameTemplateResponseModel.fromJson(item))
            .toList()),
        headers: [contentJson],
      );

  Stream<NewGameResponseModel> createNewGame({
    @required String templateId,
    @required String userId,
  }) =>
      post(
        path: 'createGame',
        body: {'templateId': templateId, 'userId': userId},
        responseMapper: response_mappers.standard(
          (json) => NewGameResponseModel.fromJson(json),
        ),
        headers: [contentJson],
      );
}
