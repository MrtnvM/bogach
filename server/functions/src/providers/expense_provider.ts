import * as uuid from 'uuid';
import { FirestoreSelector } from './firestore_selector';
import { GameId } from '../models/domain/game';
import { ExpenseEntity, Expense } from '../models/domain/expense';
import { UserId } from '../models/domain/user';
import { Firestore } from '../core/firebase/firestore';

export class ExpenseProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameId: GameId
  ) {}

  async getAllExpenses(userId: UserId): Promise<Expense[]> {
    const selector = this.selector.expenses(this.gameId, userId);
    const expenses = await this.firestore.getItems(selector);
    expenses.forEach(ExpenseEntity.validate);
    return expenses as Expense[];
  }

  async getExpense(userId: UserId, expenseId: ExpenseEntity.Id): Promise<Expense> {
    const selector = this.selector.expense(this.gameId, userId, expenseId);
    const expense = (await this.firestore.getItem(selector)).data();
    ExpenseEntity.validate(expense);
    return expense as Expense;
  }

  async addExpense(userId: UserId, expense: Expense): Promise<Expense> {
    const expenseId = uuid.v4();
    const newExpense = {
      ...expense,
      id: expenseId
    };

    const selector = this.selector.expense(this.gameId, userId, expenseId);
    const createdExpense = await this.firestore.createItem(selector, newExpense);
    ExpenseEntity.validate(createdExpense);
    return createdExpense as Expense;
  }

  async updateExpense(userId: UserId, expense: Expense): Promise<Expense> {
    const expenseId = expense.id;
    if (!expenseId) {
      throw 'ERROR: Expense Provider - no expense ID on updating';
    }

    const selector = this.selector.expense(this.gameId, userId, expenseId);
    const updatedExpense = await this.firestore.updateItem(selector, expense);
    ExpenseEntity.validate(updatedExpense);
    return updatedExpense as Expense;
  }

  async deleteExpense(userId: UserId, expenseId: ExpenseEntity.Id) {
    const selector = this.selector.expense(this.gameId, userId, expenseId);
    await this.firestore.removeItem(selector);
  }

  async clearExpenses(userId: string) {
    const selector = this.selector.expenses(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
