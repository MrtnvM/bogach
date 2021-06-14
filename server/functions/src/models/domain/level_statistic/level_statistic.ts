import { Entity } from '../../../core/domain/entity';

export interface LevelStatistic {
  readonly id: LevelStatistic.Id;
  readonly statistic: { [userId: string]: number };
}

export namespace LevelStatistic {
  export type Id = string;

  export const validate = (levelStatistic: any) => {
    const entity = Entity.createEntityValidator<LevelStatistic>(levelStatistic, 'Level Statistic');

    entity.has('statistic');
  };
}
