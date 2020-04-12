import 'package:cash_flow/models/domain/game_data.dart';
import 'package:cash_flow/utils/mappers/possessions_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseService {
  const FirebaseService({@required this.firestore}) : assert(firestore != null);

  final Firestore firestore;

  Observable<GameData> getGameData(String gameId) {
    return Observable(
            firestore.collection('games').document(gameId).snapshots())
        .map(mapToGameData);
  }
}
