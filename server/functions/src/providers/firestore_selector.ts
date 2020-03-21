import * as admin from 'firebase-admin';

import { GameEntity } from '../models/domain/game/game';
import { IncomeEntity } from '../models/domain/income';
import { ExpenseEntity } from '../models/domain/expense';
import { AssetEntity } from '../models/domain/asset';
import { LiabilityEntity } from '../models/domain/liability';
import { UserId } from '../models/domain/user';
import { GameEventId } from '../models/domain/game/game_event';
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

  gameEvent = (eventId: GameEventId): DocumentReference =>
    this.firestore.collection('game-events').doc(eventId);

  incomes = (gameId: GameEntity.Id, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('incomes');

  income = (gameId: GameEntity.Id, userId: UserId, incomeId: IncomeEntity.Id): DocumentReference =>
    this.incomes(gameId, userId).doc(incomeId);

  expenses = (gameId: GameEntity.Id, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('expenses');

  expense = (
    gameId: GameEntity.Id,
    userId: UserId,
    expenseId: ExpenseEntity.Id
  ): DocumentReference => this.expenses(gameId, userId).doc(expenseId);

  assets = (gameId: GameEntity.Id, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('assets');

  asset = (gameId: GameEntity.Id, userId: UserId, assetId: AssetEntity.Id): DocumentReference =>
    this.assets(gameId, userId).doc(assetId);

  liabilities = (gameId: GameEntity.Id, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('liabilities');

  liability = (
    gameId: GameEntity.Id,
    userId: UserId,
    liabilityId: LiabilityEntity.Id
  ): DocumentReference => this.liabilities(gameId, userId).doc(liabilityId);

  possessionState = (gameId: GameEntity.Id, userId: UserId) =>
    this.game(gameId)
      .collection('possession_state')
      .doc(userId);

  account = (gameId: GameEntity.Id, userId: UserId) =>
    this.game(gameId)
      .collection('accounts')
      .doc(userId);
}
