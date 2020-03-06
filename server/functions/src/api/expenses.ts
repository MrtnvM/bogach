import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { ExpenseEntity } from '../models/domain/expense';
import { ExpenseProvider } from '../providers/expense_provider';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const create = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const context = apiRequest.getContext();
    const expense = apiRequest.parseEntity('expense', ExpenseEntity.parse);

    const expenseProvider = new ExpenseProvider(firestore, selector, context.gameId);
    const createdIncome = await expenseProvider.addExpense(context.userId, expense);

    response.status(200).send(createdIncome);
  });

  const getAll = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);
    const context = apiRequest.getContext();

    const expenseProvider = new ExpenseProvider(firestore, selector, context.gameId);
    const expenses = await expenseProvider.getAllExpenses(context.userId);

    response.status(200).send(expenses);
  });

  return { create, getAll };
};
