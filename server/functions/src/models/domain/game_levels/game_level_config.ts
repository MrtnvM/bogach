import { GameTemplate, GameTemplateEntity } from '../game/game_template';
import { Entity } from '../../../core/domain/entity';
import { GameLevelEntity } from './game_level';
import { Rule } from '../../../generators/generator_rule';

export interface GameLevelConfig {
  readonly id: GameLevelEntity.Id;
  readonly template: GameTemplate;
  readonly rules: Rule[];
}

export namespace GameLevelConfigEntity {
  export const validate = (config: any) => {
    const entity = Entity.createEntityValidator<GameLevelConfig>(config, 'Game Level Config');

    entity.hasStringValue('id');
    entity.hasObjectValue('template', GameTemplateEntity.validate);
    entity.hasArrayValue('rules');
  };
}
