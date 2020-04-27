import 'package:cash_flow/api_client/cash_flow_api_client.dart';
import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/domain/game_data.dart';
import 'package:cash_flow/models/domain/player_action.dart';
import 'package:cash_flow/utils/mappers/game_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GameService {
  GameService({
    @required this.apiClient,
    @required this.firestore,
  })  : assert(apiClient != null),
        assert(firestore != null);

  final CashFlowApiClient apiClient;
  final Firestore firestore;

  Stream<GameData> getGameData(String gameId) {
    return firestore
        .collection('games')
        .document(gameId)
        .snapshots()
        .map(mapToGameData);
  }

  Stream<void> sendPlayerAction({
    @required GameContext context,
    @required String eventId,
    @required PlayerAction action,
  }) {
    return apiClient.sendPlayerAction(context, action, eventId);
  }
}
