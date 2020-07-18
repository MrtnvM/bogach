import { Entity } from '../../../core/domain/entity';

export interface GameLevel {
  readonly name: string;
}

export namespace GameLevelEntity {
  export const validate = (gameLevel: any) => {
    const entity = Entity.createEntityValidator<GameLevel>(gameLevel, 'Game Level');

    entity.hasStringValue('name');
  };
}
