import { GameLevel, GameLevelEntity } from './game_level';
import { Entity } from '../../../core/domain/entity';

export interface GameLevelConfig {
  readonly gameLevels: GameLevel[];
}

export namespace GameLevelConfigEntity {
  export const validate = (config: any) => {
    const entity = Entity.createEntityValidator<GameLevelConfig>(config, 'GameLevelConfig');

    entity.hasArrayValue('gameLevels');

    const levelsConfig = config as GameLevelConfig;
    levelsConfig.gameLevels.forEach(GameLevelEntity.validate);
  };
}
