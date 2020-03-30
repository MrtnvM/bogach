import { Income } from './income';
import { Expense } from './expense';
import { Asset } from './asset';
import { Liability } from './liability';
import { removeKeys } from '../../utils/object';

export interface PossessionState {
  readonly incomes: Income[];
  readonly expenses: Expense[];
  readonly assets: Asset[];
  readonly liabilities: Liability[];
}

export namespace PossessionStateEntity {
  export const normalize = (possessionState: PossessionState) => {
    const newState = JSON.parse(JSON.stringify(possessionState)) as PossessionState;
    removeKeys(newState, ['id']);
    return newState;
  };

  export const createEmpty = (): PossessionState => ({
    incomes: [],
    expenses: [],
    assets: [],
    liabilities: []
  });
}
