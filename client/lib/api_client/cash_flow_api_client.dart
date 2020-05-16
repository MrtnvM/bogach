library cash_flow_api;

import 'package:cash_flow/api_client/headers.dart';
import 'package:cash_flow/models/network/responses/game_template_response_model.dart';
import 'package:cash_flow/models/network/responses/new_game_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_network/flutter_platform_network.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/api_client/response_mappers.dart' as rm;

class CashFlowApiClient extends ApiClient {
  CashFlowApiClient({
    @required ApiEnvironment environment,
    @required Dio dio,
  }) : super(environment: environment, dio: dio, delegate: null);

  Stream<List<GameTemplateResponseModel>> getGameTemplates() => get(
        path: 'getAllGameTemplates',
        responseMapper: rm.jsonArray((json) => json
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
        responseMapper: rm.standard(
          (json) => NewGameResponseModel.fromJson(json),
        ),
        headers: [contentJson],
      );

  Stream<void> sendPlayerAction(PlayerActionRequestModel playerAction) => post(
        path: 'handleGameEvent',
        body: playerAction == null ? null : playerAction.toJson(),
        responseMapper: rm.voidResponse,
      );
}
