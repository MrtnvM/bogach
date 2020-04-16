import * as admin from 'firebase-admin';

import { GameEntity } from '../models/domain/game/game';
import { GameTemplateEntity } from '../models/domain/game/game_template';

export type DocumentReference = FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>;
export type CollectionReference = FirebaseFirestore.CollectionReference<
  FirebaseFirestore.DocumentData
>;

export class FirestoreSelector {
  constructor(private firestore: admin.firestore.Firestore) {}

  games = (): CollectionReference => this.firestore.collection('games');
  game = (gameId: GameEntity.Id): DocumentReference => this.games().doc(gameId);

  gameTemplates = (): CollectionReference => this.firestore.collection('game_templates');
  gameTemplate = (templateId: GameTemplateEntity.Id) => this.gameTemplates().doc(templateId);
}
