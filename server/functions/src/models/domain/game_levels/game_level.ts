import { Entity } from '../../../core/domain/entity';
import { GameTemplate } from '../game/game_template';
import { Rule } from '../../../generators/generator_rule';

export interface GameLevel {
  readonly id: GameLevelEntity.Id;
  readonly name: string;
  readonly icon: string;
  readonly template: GameTemplate;
  readonly rules: Rule[];
}

export namespace GameLevelEntity {
  export type Id = string;

  export const validate = (gameLevel: any) => {
    const entity = Entity.createEntityValidator<GameLevel>(gameLevel, 'Game Level');

    entity.hasStringValue('id');
    entity.hasStringValue('name');
    entity.hasStringValue('icon');
  };
}
