import * as admin from 'firebase-admin';

import { GameId } from '../models/domain/game';
import { IncomeEntity } from '../models/domain/income';
import { ExpenseEntity } from '../models/domain/expense';
import { AssetEntity } from '../models/domain/asset';
import { LiabilityEntity } from '../models/domain/liability';
import { UserId } from '../models/domain/user';
import { GameEventId } from '../models/domain/game_event';

export type DocumentReference = FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>;
export type CollectionReference = FirebaseFirestore.CollectionReference<
  FirebaseFirestore.DocumentData
>;

export class FirestoreSelector {
  constructor(private firestore: admin.firestore.Firestore) {}

  games = (): CollectionReference => this.firestore.collection('games');
  game = (gameId: GameId): DocumentReference => this.games().doc(gameId);

  gameEvent = (eventId: GameEventId): DocumentReference =>
    this.firestore.collection('game-events').doc(eventId);

  incomes = (gameId: GameId, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('incomes');

  income = (gameId: GameId, userId: UserId, incomeId: IncomeEntity.Id): DocumentReference =>
    this.incomes(gameId, userId).doc(incomeId);

  expenses = (gameId: GameId, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('expenses');

  expense = (gameId: GameId, userId: UserId, expenseId: ExpenseEntity.Id): DocumentReference =>
    this.expenses(gameId, userId).doc(expenseId);

  assets = (gameId: GameId, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('assets');

  asset = (gameId: GameId, userId: UserId, assetId: AssetEntity.Id): DocumentReference =>
    this.assets(gameId, userId).doc(assetId);

  liabilities = (gameId: GameId, userId: UserId): CollectionReference =>
    this.game(gameId)
      .collection('possessions')
      .doc(userId)
      .collection('liabilities');

  liability = (
    gameId: GameId,
    userId: UserId,
    liabilityId: LiabilityEntity.Id
  ): DocumentReference => this.liabilities(gameId, userId).doc(liabilityId);
}
