import { Entity } from '../../../core/domain/entity';

export interface GameTarget {
  readonly type: GameTargetEntity.Type;
  readonly value: number;
}

export namespace GameTargetEntity {
  export type Type = 'passive_income' | 'cash';
  const TypeValues = ['passive_income', 'cash'];

  export const parse = (data: any): GameTarget => {
    const { type, value } = data;

    let game: GameTarget = {
      type,
      value
    };

    validate(game);
    return game;
  };

  export const validate = (game: any) => {
    const entity = Entity.createEntityValidator<GameTarget>(game);

    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);
    entity.hasValue('value');
  };
}
