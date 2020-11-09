import * as admin from 'firebase-admin';
import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';

export class RealtimeDatabaseRefs {
  constructor(private db: admin.database.Database) {}

  games = () => this.db.ref('games');
  game = (gameId: GameEntity.Id) => this.games().child(gameId);

  gameParticipant = (userId: UserEntity.Id, gameId: GameEntity.Id) => {
    const participantsKey: keyof Game = 'participants';

    const gameRef = this.game(gameId);
    const participantRef = gameRef.child(participantsKey).child(userId);
    return participantRef;
  };
}
