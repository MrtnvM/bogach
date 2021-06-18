import { Entity } from '../../../core/domain/entity';

/// LevelStatictics - this is a data that is displaying on the singleplayer winner page.
/// `statistic` map field contains:
///    - key - userId,
///    - value - month count that was needed for the archiving the goal
///
/// On the mobile winner page displaying how better the current user pass the level related to other players
/// calculated in the percent of the all winner players
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
