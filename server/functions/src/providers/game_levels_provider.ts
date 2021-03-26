import { GameLevel, GameLevelEntity } from '../game_levels/models/game_level';
import { GameLevels } from '../game_levels/game_levels';

export class GameLevelsProvider {
  getGameLevels(): GameLevel[] {
    return GameLevels.gameLevelsIds.map((id) => GameLevels.levelsMap[id]);
  }

  getGameLevel(gameLevelId: GameLevelEntity.Id): GameLevel {
    return GameLevels.levelsMap[gameLevelId];
  }
}
