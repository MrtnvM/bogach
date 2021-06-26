import { GameTemplateEntity } from '../game_templates/models/game_template';
import { LevelStatistic } from '../models/domain/level_statistic/level_statistic';

export interface ILevelStatisticDAO {
  getLevelStatistic(templateId: GameTemplateEntity.Id): Promise<LevelStatistic>;
  updateLevelStatistic(statistic: LevelStatistic): Promise<LevelStatistic>;
}
