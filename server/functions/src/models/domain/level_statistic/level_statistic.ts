import { Entity } from '../../../core/domain/entity';
import { UserEntity } from '../user/user';

export interface LevelStatistic {
  readonly id: LevelStatistic.Id;
  readonly statistic: Map<UserEntity.Id, number>;
}

export namespace LevelStatistic {
  export type Id = string;

  export const validate = (levelStatistic: any) => {
    const entity = Entity.createEntityValidator<LevelStatistic>(levelStatistic, 'Level Statistic');

    entity.has('statistic');
  };
}
