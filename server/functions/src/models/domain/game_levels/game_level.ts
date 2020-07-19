import { Entity } from '../../../core/domain/entity';
import { GameTemplateEntity } from '../game/game_template';

export interface GameLevel {
  readonly id: GameLevelEntity.Id;
  readonly name: string;
  readonly icon: string;
  readonly gameTemplateId: GameTemplateEntity.Id;
}

export namespace GameLevelEntity {
  export type Id = string;

  export const validate = (gameLevel: any) => {
    const entity = Entity.createEntityValidator<GameLevel>(gameLevel, 'Game Level');

    entity.hasStringValue('id');
    entity.hasStringValue('name');
    entity.hasStringValue('icon');
    entity.hasStringValue('gameTemplateId');
  };
}
