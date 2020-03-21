import * as uuid from 'uuid';
import { FirestoreSelector } from './firestore_selector';
import { GameEntity } from '../models/domain/game/game';
import { IncomeEntity, Income } from '../models/domain/income';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';

export class IncomeProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameEntity.Id
  ) {}

  async getAllIncomes(userId: UserId): Promise<Income[]> {
    const selector = this.selector.incomes(this.gameId, userId);
    const incomes = await this.firestore.getItems(selector);
    incomes.forEach(IncomeEntity.validate);
    return incomes as Income[];
  }

  async getIncome(userId: UserId, incomeId: IncomeEntity.Id): Promise<Income> {
    const selector = this.selector.income(this.gameId, userId, incomeId);
    const income = (await this.firestore.getItem(selector)).data();
    IncomeEntity.validate(income);
    return income as Income;
  }

  async addIncome(userId: UserId, income: Income): Promise<Income> {
    const incomeId = uuid.v4();
    const newIncome = {
      ...income,
      id: incomeId
    };

    const selector = this.selector.income(this.gameId, userId, incomeId);
    const createdIncome = await this.firestore.createItem(selector, newIncome);
    IncomeEntity.validate(createdIncome);
    return createdIncome as Income;
  }

  async updateIncome(userId: UserId, income: Income): Promise<Income> {
    const incomeId = income.id;
    if (!incomeId) {
      throw 'ERROR: Income Provider - no income ID on updating';
    }

    const selector = this.selector.income(this.gameId, userId, incomeId);
    const updatedIncome = await this.firestore.updateItem(selector, income);
    IncomeEntity.validate(updatedIncome);
    return updatedIncome as Income;
  }

  async deleteIncome(userId: UserId, incomeId: IncomeEntity.Id) {
    const selector = this.selector.income(this.gameId, userId, incomeId);
    await this.firestore.removeItem(selector);
  }

  async clearIncomes(userId: string) {
    const selector = this.selector.incomes(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
