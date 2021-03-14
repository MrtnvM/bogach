library cash_flow_api;

import 'package:cash_flow/api_client/headers.dart';
import 'package:cash_flow/api_client/response_mappers.dart' as rm;
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/online/online_profile.dart';
import 'package:cash_flow/models/domain/user/purchase_profile.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/models/network/request/purchases/update_purchases_request_model.dart';
import 'package:cash_flow/models/network/responses/game_template_response_model.dart';
import 'package:cash_flow/models/network/responses/new_game_response_model.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CashFlowApiClient extends ApiClient {
  CashFlowApiClient({
    @required ApiEnvironment environment,
    @required Dio dio,
  }) : super(environment: environment, dio: dio, delegate: null);

  Future<List<GameTemplateResponseModel>> getGameTemplates() => get(
        path: 'getAllGameTemplates',
        responseMapper: rm.jsonArray((json) => json
            .map((item) => GameTemplateResponseModel.fromJson(item))
            .toList()),
        headers: [contentJson],
      );

  Future<List<Quest>> getQuests(String userId) => get(
        path: 'gameLevels?user_id=$userId',
        responseMapper: rm.jsonArray(
          (json) => json.map((item) => Quest.fromJson(item)).toList(),
        ),
      );

  Future<NewGameResponseModel> createNewGame({
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

  Future<NewGameResponseModel> createNewQuestGame({
    @required String questId,
    @required String userId,
  }) =>
      post(
        path: 'createGameByLevel',
        body: {'gameLevelId': questId, 'userId': userId},
        responseMapper: rm.standard(
          (json) => NewGameResponseModel.fromJson(json),
        ),
        headers: [contentJson],
      );

  Future<void> sendPlayerAction(PlayerActionRequestModel playerAction) => post(
        path: 'handleGameEvent',
        body: playerAction.toJson(),
        validate: false,
        headers: [contentJson],
        responseMapper: rm.standard((json) => null),
      );

  Future<void> startNewMonth(GameContext gameContext) => post(
        path: 'startNewMonth',
        body: {'context': gameContext.toJson()},
        responseMapper: rm.voidResponse,
      );

  Future<Room> createRoom(CreateRoomRequestModel requestModel) => post(
        path: 'createRoom',
        body: requestModel.toJson(),
        responseMapper: rm.standard((json) => Room.fromJson(json)),
      );

  Future<void> setRoomParticipantReady(String roomId, String participantId) =>
      post(
        path: 'setRoomParticipantReady',
        body: {
          'roomId': roomId,
          'participantId': participantId,
        },
        responseMapper: rm.voidResponse,
      );

  Future<void> createRoomGame(String roomId) => post(
        path: 'createRoomGame',
        body: {'roomId': roomId},
        responseMapper: rm.voidResponse,
      );

  Future<PurchaseProfile> sendPurchasedProducts(
    UpdatePurchasesRequestModel updatedPurchases,
  ) =>
      post(
        path: 'updatePurchases',
        body: updatedPurchases.toJson(),
        responseMapper: rm.standard((json) => PurchaseProfile.fromJson(json)),
      );

  Future<UserProfile> getUserProfile(String userId) => get(
        path: 'getUserProfile?userId=$userId',
        headers: [contentJson],
        responseMapper: rm.standard((json) => UserProfile.fromJson(json)),
      );

  Future<void> setOnlineStatus(OnlineProfile user) => post(
        path: 'setOnlineStatus',
        headers: [contentJson],
        body: user.toJson(),
        responseMapper: rm.voidResponse,
      );

  Future<List<OnlineProfile>> getOnlineProfiles(String id) => get(
      path: 'getOnlineProfiles?user_id=$id',
      headers: [contentJson],
      responseMapper: rm.jsonArray(
        (json) => json.map((item) => OnlineProfile.fromJson(item)).toList(),
      ));

  Future<void> addFriends(
    String userId,
    List<String> usersAddToFriends,
  ) =>
      post(
        path: 'addFriends',
        body: {
          'userId': userId,
          'usersAddToFriends': usersAddToFriends,
        },
        validate: true,
      );
}
