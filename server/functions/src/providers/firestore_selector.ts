import * as admin from 'firebase-admin';

import { GameEntity } from '../models/domain/game/game';
import { GameTemplateEntity } from '../models/domain/game/game_template';
import { RoomEntity } from '../models/domain/room';
import { UserEntity } from '../models/domain/user';

export type DocumentReference = FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>;
export type CollectionReference = FirebaseFirestore.CollectionReference<
  FirebaseFirestore.DocumentData
>;

export type Query = FirebaseFirestore.Query;

export class FirestoreSelector {
  constructor(private firestore: admin.firestore.Firestore) {}

  games = (): CollectionReference => this.firestore.collection('games');
  game = (gameId: GameEntity.Id): DocumentReference => this.games().doc(gameId);

  gameTemplates = (): CollectionReference => this.firestore.collection('game_templates');
  gameTemplate = (templateId: GameTemplateEntity.Id) => this.gameTemplates().doc(templateId);

  rooms = (): CollectionReference => this.firestore.collection('rooms');
  room = (roomId: RoomEntity.Id) => this.rooms().doc(roomId);

  // TODO(Maxim): Implement support of several user devices
  device = (userId: UserEntity.Id) => this.firestore.collection('devices').doc(userId);

  users = (): CollectionReference => this.firestore.collection('users');
  user = (userId: UserEntity.Id) => this.users().doc(userId);
  userPurchases = (userId: UserEntity.Id) => this.user(userId).collection('purchases');
}
