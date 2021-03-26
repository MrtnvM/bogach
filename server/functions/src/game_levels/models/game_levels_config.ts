import { GameLevel, GameLevelEntity } from './game_level';
import { Entity } from '../../core/domain/entity';

export interface GameLevelsConfig {
  readonly levelsMap: { [levelId: string]: GameLevel };
  readonly gameLevelsIds: GameLevelEntity.Id[];
}

export namespace GameLevelsConfigEntity {
  export const validate = (config: any) => {
    const entity = Entity.createEntityValidator<GameLevelsConfig>(config, 'GameLevelConfig');

    entity.hasValue('levelsMap');
    entity.hasArrayValue('gameLevelsIds');

    const levelsConfig = config as GameLevelsConfig;
    levelsConfig.gameLevelsIds.forEach((id) =>
      GameLevelEntity.validate(levelsConfig.levelsMap[id])
    );
  };
}
