import { GameLevel, GameLevelEntity } from './game_level';
import { Entity } from '../../../core/domain/entity';

export interface GameLevelsConfig {
  readonly gameLevels: GameLevel[];
}

export namespace GameLevelsConfigEntity {
  export const validate = (config: any) => {
    const entity = Entity.createEntityValidator<GameLevelsConfig>(config, 'GameLevelConfig');

    entity.hasArrayValue('gameLevels');

    const levelsConfig = config as GameLevelsConfig;
    levelsConfig.gameLevels.forEach(GameLevelEntity.validate);
  };
}
