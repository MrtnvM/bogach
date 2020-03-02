import * as uuid from 'uuid';
import { FirestoreSelector } from './firestore_selector';
import { GameId } from '../models/domain/game';
import { IncomeEntity, Income } from '../models/domain/income';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';

export class IncomeProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameId
  ) {}

  async getAllIncomes(userId: UserId) {
    const selector = this.selector.incomes(this.gameId, userId);
    const incomes = await this.firestore.getItems(selector);
    return incomes;
  }

  async getIncome(userId: UserId, incomeId: IncomeEntity.Id) {
    const selector = this.selector.income(this.gameId, userId, incomeId);
    const income = await this.firestore.getItem(selector);
    return income;
  }

  async addIncome(userId: UserId, income: Income) {
    const incomeId = uuid.v4();
    const newIncome = {
      ...income,
      id: incomeId
    };

    const selector = this.selector.income(this.gameId, userId, incomeId);
    const createdIncome = await this.firestore.createItem(selector, newIncome);
    return createdIncome;
  }

  async updateIncome(userId: UserId, income: Income) {
    const incomeId = income.id;
    if (!incomeId) {
      throw 'ERROR: Income Provider - no income ID on updating';
    }

    const selector = this.selector.income(this.gameId, userId, incomeId);
    const updatedIncome = await this.firestore.updateItem(selector, income);
    return updatedIncome;
  }

  async deleteIncome(userId: UserId, incomeId: IncomeEntity.Id) {
    const selector = this.selector.income(this.gameId, userId, incomeId);
    this.firestore.removeItem(selector);
  }

  async clearIncomes(userId: string) {
    const selector = this.selector.incomes(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
