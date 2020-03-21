import { Entity } from '../../core/domain/entity';

export interface Account {
  readonly id?: AccountEntity.Id;
  readonly balance: number;
  readonly credit: number;
  readonly cashFlow: number;
  readonly updatedAt?: Date;
}

export namespace AccountEntity {
  export type Id = string;

  export const parse = (data: any): Account => {
    const { id, balance, credit, cashFlow, updatedAt } = data;
    let account: Account = { id, balance, credit, cashFlow, updatedAt };

    validate(account);

    return account;
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<Account>(asset);

    entity.hasValue('balance');
    entity.hasValue('credit');
    entity.hasValue('cashFlow');

    entity.checkWithRules([[a => a.credit >= 0, "Credit value can't be >= 0"]]);
  };
}
