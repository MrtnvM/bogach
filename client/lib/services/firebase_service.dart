import 'package:cash_flow/models/state/posessions_state/user_possession_state.dart';
import 'package:cash_flow/utils/mappers/possessions_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseService {
  const FirebaseService({@required this.firestore}) : assert(firestore != null);

  final Firestore firestore;

  Observable<UserPossessionState> getPossessionsStates(String gameId) {
    return Observable(
            firestore.collection('games').document(gameId).snapshots())
        .map(mapToPossessionState);
  }
}
