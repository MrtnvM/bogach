import * as admin from 'firebase-admin';
import { GameEntity } from '../../models/domain/game/game';

export class RealtimeDatabaseRefs {
  constructor(private db: admin.database.Database) {}

  games = () => this.db.ref('games');
  game = (gameId: GameEntity.Id) => this.games().child(gameId);
}
