import { Game, GameEntity } from '../models/domain/game/game';
import { UserEntity } from '../models/domain/user/user';

export interface IGameDAO {
  getGame(gameId: GameEntity.Id): Promise<Game>;
  createGame(game: Game): Promise<Game>;
  updateGame(game: Game): Promise<Game>;
  updateGameForUser(game: Game, userId: UserEntity.Id): Promise<void>;
  deleteGame(gameId: GameEntity.Id): Promise<void>;
}
