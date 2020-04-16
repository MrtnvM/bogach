import { Entity } from '../../core/domain/entity';

export interface Account {
  readonly id?: AccountEntity.Id;
  readonly cash: number;
  readonly credit: number;
  readonly cashFlow: number;
}

export namespace AccountEntity {
  export type Id = string;

  export const parse = (data: any): Account => {
    const { id, balance, credit, cashFlow } = data;
    const account: Account = { id, cash: balance, credit, cashFlow };

    validate(account);

    return account;
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<Account>(asset, 'Account');

    entity.hasNumberValue('cash');
    entity.hasNumberValue('credit');
    entity.hasNumberValue('cashFlow');

    entity.checkWithRules([
      [(a) => a.credit < 0, "Credit value can't be < 0"],
      [(a) => a.cash < 0, "Balance value can't be < 0"],
    ]);
  };
}
