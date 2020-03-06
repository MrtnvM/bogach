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

  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace PossessionStateEntity {
  export const normalize = (possessionState: PossessionState) => {
    const newState = JSON.parse(JSON.stringify(possessionState)) as PossessionState;
    removeKeys(newState, ['createdAt', 'updatedAt', 'id']);
    return newState;
  };
}
