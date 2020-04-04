import { Income, IncomeEntity } from './income';
import { Expense, ExpenseEntity } from './expense';
import { Asset, AssetEntity } from './asset';
import { Liability } from './liability';
import { Entity } from '../../core/domain/entity';

export interface Possessions {
  readonly incomes: Income[];
  readonly expenses: Expense[];
  readonly assets: Asset[];
  readonly liabilities: Liability[];
}

export namespace PossessionsEntity {
  export const createEmpty = (): Possessions => ({
    incomes: [],
    expenses: [],
    assets: [],
    liabilities: [],
  });

  export const validate = (possessions: any) => {
    const entity = Entity.createEntityValidator<Possessions>(possessions, 'Possessions');

    entity.hasValue('incomes');
    entity.hasValue('expenses');
    entity.hasValue('assets');
    entity.hasValue('liabilities');

    const possessionsEntity = possessions as Possessions;

    possessionsEntity.incomes.forEach(IncomeEntity.validate);
    possessionsEntity.expenses.forEach(ExpenseEntity.validate);
    possessionsEntity.assets.forEach(AssetEntity.validate);
    possessionsEntity.liabilities.forEach(PossessionsEntity.validate);
  };
}
