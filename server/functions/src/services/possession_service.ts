import { IncomeProvider } from '../providers/income_provider';
import { UserId } from '../models/domain/user';
import { ExpenseProvider } from '../providers/expense_provider';
import { AssetProvider } from '../providers/asset_provider';
import { LiabilityProvider } from '../providers/liability_provider';
import { PossessionStateProvider } from '../providers/possession_state_provider';
import { Income } from '../models/domain/income';
import { AssetEntity } from '../models/domain/asset';
import { LiabilityEntity } from '../models/domain/liability';
import { Possessions } from '../models/domain/possessions';
import { PossessionState, PossessionStateEntity } from '../models/domain/possession_state';

export class PossessionService {
  constructor(
    private incomeProvider: IncomeProvider,
    private expenseProvider: ExpenseProvider,
    private assetProvider: AssetProvider,
    private liabilityProvider: LiabilityProvider,
    private possessionStateProvider: PossessionStateProvider
  ) {}

  async getPossissions(userId: UserId): Promise<Possessions> {
    const possessions = await Promise.all([
      this.incomeProvider.getAllIncomes(userId),
      this.expenseProvider.getAllExpenses(userId),
      this.assetProvider.getAllAssets(userId),
      this.liabilityProvider.getAllLiabilities(userId)
    ]);

    return {
      incomes: possessions[0] as Income[],
      expenses: possessions[1],
      assets: possessions[2],
      liabilities: possessions[3]
    };
  }

  async generatePossessionState(userId: UserId) {
    const possessions = await this.getPossissions(userId);

    const incomes = possessions.incomes.slice();
    const expenses = possessions.expenses.slice();
    const assets = possessions.assets.slice();
    const liabilities = possessions.liabilities.slice();

    assets.forEach(asset => {
      const income = AssetEntity.getIncome(asset);
      if (income) incomes.push(income);

      const expense = AssetEntity.getExpense(asset);
      if (expense) expenses.push(expense);
    });

    liabilities.forEach(liability => {
      const expense = LiabilityEntity.getExpense(liability);
      if (expense) expenses.push(expense);
    });

    const newPossessionState: PossessionState = { incomes, expenses, assets, liabilities };
    return PossessionStateEntity.normalize(newPossessionState);
  }

  async updatePossessionState(userId: UserId) {
    const newPossessionState = await this.generatePossessionState(userId);

    const state = await this.possessionStateProvider.updatePossessionState(
      userId,
      newPossessionState
    );

    return state;
  }
}
