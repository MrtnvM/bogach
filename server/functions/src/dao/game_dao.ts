import { GameTemplateEntity } from '../game_templates/models/game_template';
import { Game, GameEntity } from '../models/domain/game/game';
import { LevelStatistic } from '../models/domain/level_statistic/level_statistic';
import { UserEntity } from '../models/domain/user/user';

export interface IGameDAO {
  getGame(gameId: GameEntity.Id): Promise<Game>;
  createGame(game: Game): Promise<Game>;
  updateGame(game: Game): Promise<Game>;
  updateGameWithoutParticipants(game: Game): Promise<void>;
  updateParticipant(game: Game, userId: UserEntity.Id): Promise<void>;
  deleteGame(gameId: GameEntity.Id): Promise<void>;
  getLevelStatistic(templateId: GameTemplateEntity.Id): Promise<LevelStatistic>;
  updateLevelStatistic(statistic: LevelStatistic): Promise<LevelStatistic>;
}
