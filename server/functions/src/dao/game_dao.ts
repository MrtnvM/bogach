import { Game, GameEntity } from '../models/domain/game/game';

export interface IGameDAO {
  getGame(gameId: GameEntity.Id): Promise<Game>;
  createGame(game: Game): Promise<Game>;
  updateGame(game: Game): Promise<Game>;
  deleteGame(gameId: GameEntity.Id): Promise<void>;
}
