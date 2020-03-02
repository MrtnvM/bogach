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

  async getAllExpenses(userId: UserId) {
    const selector = this.selector.expenses(this.gameId, userId);
    const expenses = await this.firestore.getItems(selector);
    return expenses;
  }

  async getExpense(userId: UserId, expenseId: ExpenseEntity.Id) {
    const selector = this.selector.expense(this.gameId, userId, expenseId);
    const expense = await this.firestore.getItem(selector);
    return expense;
  }

  async addExpense(userId: UserId, expense: Expense) {
    const expenseId = uuid.v4();
    const newExpense = {
      ...expense,
      id: expenseId
    };

    const selector = this.selector.expense(this.gameId, userId, expenseId);
    const createdExpense = await this.firestore.createItem(selector, newExpense);
    return createdExpense;
  }

  async updateExpense(userId: UserId, expense: Expense) {
    const expenseId = expense.id;
    if (!expenseId) {
      throw 'ERROR: Expense Provider - no expense ID on updating';
    }

    const selector = this.selector.expense(this.gameId, userId, expenseId);
    const updatedExpense = await this.firestore.updateItem(selector, expense);
    return updatedExpense;
  }

  async deleteExpense(userId: UserId, expenseId: ExpenseEntity.Id) {
    const selector = this.selector.expense(this.gameId, userId, expenseId);
    this.firestore.removeItem(selector);
  }

  async clearExpenses(userId: string) {
    const selector = this.selector.expenses(this.gameId, userId);
    return this.firestore.removeItems(selector);
  }
}
