import { GameLevelEntity } from '../game_levels/models/game_level';
import { Game, GameEntity } from '../models/domain/game/game';
import { UserEntity } from '../models/domain/user';

export interface IGameDAO {
  createGame(game: Game): Promise<Game>;
  updateGame(game: Game): Promise<Game>;
  deleteGame(gameId: GameEntity.Id): Promise<void>;

  getGame(gameId: GameEntity.Id): Promise<Game>;
  getGames(): Promise<Game[]>;

  getUserQuestGames(userId: UserEntity.Id, levelIds: GameLevelEntity.Id[]): Promise<Game[]>;
  removeUserQuestGamesForLevel(userId: UserEntity.Id, levelId: GameLevelEntity.Id): Promise<void>;
}
