import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/utils/mappers/new_game_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class GameService {
  GameService({
    @required this.apiClient,
    @required this.firestore,
    @required this.firebaseDatabase,
  })  : assert(apiClient != null),
        assert(firestore != null),
        assert(firebaseDatabase != null);

  final CashFlowApiClient apiClient;
  final Firestore firestore;
  final FirebaseDatabase firebaseDatabase;

  Stream<List<GameTemplate>> getGameTemplates() {
    return apiClient.getGameTemplates().map(mapToGameTemplates);
  }

  Stream<String> createNewGame({
    @required String templateId,
    @required String userId,
  }) {
    return apiClient
        .createNewGame(templateId: templateId, userId: userId)
        .map((response) => response.id);
  }

  Stream<Game> getGame(GameContext gameContext) {
    return firestore
        .collection('games')
        .document(gameContext.gameId)
        .snapshots()
        .map((snapshot) => Game.fromJson(snapshot.data));
  }

  Stream<Game> getGameFromRealtimeDb(String gameId) {
    return firebaseDatabase
        .reference()
        .child('games')
        .child(gameId)
        .onValue
        .map((event) => Game.fromJson(event.snapshot.value));
  }

  Future<List<Game>> getUserGames(String userId) async {
    final gameDocs = await firestore
        .collection('games')
        .where('participants', arrayContains: userId)
        .getDocuments();

    final games = gameDocs.documents.map((d) => Game.fromJson(d.data)).toList();

    return games;
  }

  Stream<void> sendPlayerAction(PlayerActionRequestModel playerAction) {
    return apiClient.sendPlayerAction(playerAction);
  }
}
