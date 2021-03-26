import { Entity } from '../../core/domain/entity';

export interface Account {
  readonly id?: AccountEntity.Id;
  readonly cash: number;
  readonly credit: number;
  readonly cashFlow: number;
}

export namespace AccountEntity {
  export type Id = string;

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<Account>(asset, 'Account');

    entity.hasNumberValue('cash');
    entity.hasNumberValue('credit');
    entity.hasNumberValue('cashFlow');

    entity.checkWithRules([[(a) => a.credit < 0, "Credit value can't be < 0"]]);
  };
}
