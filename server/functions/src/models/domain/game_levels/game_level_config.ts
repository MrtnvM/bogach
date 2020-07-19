import { GameTemplate, GameTemplateEntity } from '../game/game_template';
import { Entity } from '../../../core/domain/entity';

export interface GameLevelConfig {
  readonly template: GameTemplate;
}

export namespace GameLevelConfigEntity {
  export const validate = (config: any) => {
    const entity = Entity.createEntityValidator<GameLevelConfig>(config, 'Game Level Config');

    entity.hasObjectValue('template', GameTemplateEntity.validate);
  };
}
