import { Income } from './income';
import { Expense } from './expense';
import { Asset } from './asset';
import { Liability } from './liability';

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
    liabilities: []
  });
}
