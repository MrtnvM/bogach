library cash_flow_api;

import 'package:cash_flow/api_client/headers.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/models/network/responses/game_template_response_model.dart';
import 'package:cash_flow/models/network/responses/new_game_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
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

  Stream<List<GameLevel>> getGameLevels() => get(
        path: 'gameLevels',
        responseMapper: rm.jsonArray(
          (json) => json.map((item) => GameLevel.fromJson(item)).toList(),
        ),
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

  Stream<NewGameResponseModel> createNewGameByLevel({
    @required String gameLevelId,
    @required String userId,
  }) =>
      post(
        path: 'createGameByLevel',
        body: {'gameLevelId': gameLevelId, 'userId': userId},
        responseMapper: rm.standard(
          (json) => NewGameResponseModel.fromJson(json),
        ),
        headers: [contentJson],
      );

  Stream<void> sendPlayerAction(PlayerActionRequestModel playerAction) => post(
        path: 'handleGameEvent',
        body: playerAction.toJson(),
        validate: false,
        responseMapper: rm.voidResponse,
      );

  Stream<void> startNewMonth(GameContext gameContext) => post(
        path: 'startNewMonth',
        body: {'context': gameContext.toJson()},
        responseMapper: rm.voidResponse,
      );

  Stream<Room> createRoom(CreateRoomRequestModel requestModel) => post(
        path: 'createRoom',
        body: requestModel.toJson(),
        responseMapper: rm.standard((json) => Room.fromJson(json)),
      );

  Stream<void> setRoomParticipantReady(String roomId, String participantId) =>
      post(
        path: 'setRoomParticipantReady',
        body: {
          'roomId': roomId,
          'participantId': participantId,
        },
        responseMapper: rm.voidResponse,
      );

  Stream<void> createRoomGame(String roomId) => post(
        path: 'createRoomGame',
        body: {'roomId': roomId},
        responseMapper: rm.voidResponse,
      );
}
