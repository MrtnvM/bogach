import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { IncomeProvider } from '../providers/income_provider';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { IncomeEntity } from '../models/domain/income';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const create = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const context = apiRequest.getContext();
    const income = apiRequest.parseEntity('income', IncomeEntity.parse);

    const incomeProvider = new IncomeProvider(firestore, selector, context.gameId);
    const createdIncome = await incomeProvider.addIncome(context.userId, income);

    response.status(200).send(createdIncome);
  });

  const getAll = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);
    const context = apiRequest.getContext();

    const incomeProvider = new IncomeProvider(firestore, selector, context.gameId);
    const incomes = await incomeProvider.getAllIncomes(context.userId);

    response.status(200).send(incomes);
  });

  return { create, getAll };
};
