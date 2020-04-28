import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/domain/game_data.dart';
import 'package:cash_flow/models/network/request/game/player_action_request_model.dart';
import 'package:cash_flow/utils/mappers/game_mapper.dart';
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

  Stream<GameData> getGameData(GameContext gameContext) {
    return firestore
        .collection('games')
        .document(gameContext.gameId)
        .snapshots()
        .map((snapshot) => mapToGameData(snapshot, gameContext.userId));
  }
  Stream<GameData> getRealtimeGameData(String gameId) {
    return firebaseDatabase
        .reference()
        .child('games')
        .child('2')
        .onValue
        .map(mapToRealtimeGameData);
  }

  Stream<void> sendPlayerAction(PlayerActionRequestModel playerAction) {
    return apiClient.sendPlayerAction(playerAction);
  }
}
