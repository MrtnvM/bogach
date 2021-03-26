import * as admin from 'firebase-admin';

import { GameEntity } from '../models/domain/game/game';
import { RoomEntity } from '../models/domain/room';
import { UserEntity } from '../models/domain/user/user';

export type DocumentReference = FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>;
export type CollectionReference = FirebaseFirestore.CollectionReference<
  FirebaseFirestore.DocumentData
>;

export type Query = FirebaseFirestore.Query;

export class FirestoreSelector {
  constructor(private firestore: admin.firestore.Firestore) {}

  games = (): CollectionReference => this.firestore.collection('games');
  game = (gameId: GameEntity.Id): DocumentReference => this.games().doc(gameId);

  rooms = (): CollectionReference => this.firestore.collection('rooms');
  room = (roomId: RoomEntity.Id) => this.rooms().doc(roomId);

  // TODO(Maxim): Implement support of several user devices
  device = (userId: UserEntity.Id) => this.firestore.collection('devices').doc(userId);

  users = (): CollectionReference => this.firestore.collection('users');
  user = (userId: UserEntity.Id) => this.users().doc(userId);
  userPurchases = (userId: UserEntity.Id) => this.user(userId).collection('purchases');

  recentSessions = (): CollectionReference => this.firestore.collection('recent_sessions');
  recentSession = (userId: UserEntity.Id) => this.recentSessions().doc(userId);
}
