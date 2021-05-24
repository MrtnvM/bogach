import 'dart:convert';

import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/game/current_game_state/current_game_state.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/utils/error_handler.dart';
import 'package:cash_flow/utils/mappers/new_game_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class GameService {
  GameService({
    required this.apiClient,
    required this.firestore,
    required this.realtimeDatabase,
  });

  final CashFlowApiClient apiClient;
  final FirebaseFirestore firestore;
  final FirebaseDatabase realtimeDatabase;

  Future<List<GameTemplate>> getGameTemplates() {
    return apiClient
        .getGameTemplates()
        .then(mapToGameTemplates);
  }

  Future<List<Quest>> getQuests(String userId) {
    return apiClient.getQuests(userId);
  }

  Future<String> createNewGame({
    required String templateId,
    required String userId,
  }) {
    return apiClient
        .createNewGame(templateId: templateId, userId: userId)
        .then((response) => response.id);
  }

  Future<String> createQuestGame({
    required String gameLevelId,
    required String userId,
  }) {
    return apiClient
        .createNewQuestGame(questId: gameLevelId, userId: userId)
        .then((response) => response.id);
  }

  Stream<Game> getGame(GameContext gameContext) {
    return realtimeDatabase
        .reference()
        .child('games')
        .child(gameContext.gameId)
        .onValue
        .map((snapshot) => snapshot.snapshot.value)
        .map((data) {
      final jsonString = json.encode(data);
      final jsonData = json.decode(jsonString);
      final game = Game.fromJson(jsonData);
      return game;
    }).handleError(recordError, test: (e) => true);
  }

  Future<Game?> getGameByLevel(String levelId, String userId) async {
    final gameDocs = await firestore
        .collection('games')
        .where('participants', arrayContains: userId)
        .where('config.level', isEqualTo: levelId)
        .get();

    final games = gameDocs.docs
        .map((d) => Game.fromJson(d.data()))
        .where((g) => g.state.gameStatus != GameStatus.gameOver)
        .toList();

    if (games.isEmpty) {
      return null;
    }

    return games.first;
  }

  Future<void> sendPlayerAction(PlayerActionRequestModel playerAction) {
    return apiClient.sendPlayerAction(playerAction);
  }

  Future<void> startNewMonth(GameContext gameContext) {
    return apiClient.startNewMonth(gameContext);
  }

  Future<Room> createRoom(CreateRoomRequestModel requestModel) {
    return apiClient.createRoom(requestModel);
  }

  Future<void> setRoomParticipantReady(String? roomId, String participantId) {
    return apiClient
        .setRoomParticipantReady(roomId, participantId)
        .onError(recordError);
  }

  Future<void> createRoomGame(String roomId) {
    return apiClient.createRoomGame(roomId);
  }

  Stream<Room> subscribeOnRoomUpdates(String roomId) {
    return firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .where((snapshot) => snapshot.data() != null)
        .map((snapshot) => Room.fromJson(snapshot.data()!))
        .handleError(recordError, test: (e) => true);
  }

  Future<Room> getRoom(String roomId) {
    return firestore
        .collection('rooms')
        .doc(roomId)
        .get()
        .then((snapshot) => Room.fromJson(snapshot.data()!))
        .onError(recordError);
  }
}
