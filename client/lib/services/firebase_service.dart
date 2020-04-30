import 'package:cash_flow/models/domain/game_data.dart';
import 'package:cash_flow/utils/mappers/possessions_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseService {
  const FirebaseService({
    @required this.firestore,
  }) : assert(firestore != null);

  final Firestore firestore;

  Stream<GameData> getGameData(String gameId) {
    return firestore
        .collection('games')
        .document(gameId)
        .snapshots()
        .map(mapToGameData);
  }
}
