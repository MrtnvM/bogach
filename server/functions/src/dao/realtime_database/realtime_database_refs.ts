import * as admin from 'firebase-admin';
import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';

export class RealtimeDatabaseRefs {
  constructor(private db: admin.database.Database) {}

  games = () => this.db.ref('games');
  game = (gameId: GameEntity.Id) => this.games().child(gameId);

  participantProgress = (userId: UserEntity.Id, gameId: GameEntity.Id) => {
    const stateKey: keyof Game = 'state';
    const progressKey: keyof GameEntity.State = 'participantsProgress';

    const gameRef = this.game(gameId);
    const participantsProgressRef = gameRef.child(stateKey).child(progressKey).child(userId);
    return participantsProgressRef;
  };

  possessions = (userId: UserEntity.Id, gameId: GameEntity.Id) => {
    const possessionsKey: keyof Game = 'possessions';

    const gameRef = this.game(gameId);
    const possessionsRef = gameRef.child(possessionsKey).child(userId);
    return possessionsRef;
  };

  possessionState = (userId: UserEntity.Id, gameId: GameEntity.Id) => {
    const possessionStateKey: keyof Game = 'possessionState';

    const gameRef = this.game(gameId);
    const possessionStateRef = gameRef.child(possessionStateKey).child(userId);
    return possessionStateRef;
  };

  participantAccount = (userId: UserEntity.Id, gameId: GameEntity.Id) => {
    const accountsKey: keyof Game = 'accounts';

    const gameRef = this.game(gameId);
    const accountRef = gameRef.child(accountsKey).child(userId);
    return accountRef;
  };
}
