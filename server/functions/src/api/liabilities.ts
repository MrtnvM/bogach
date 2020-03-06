import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { LiabilityEntity } from '../models/domain/liability';
import { LiabilityProvider } from '../providers/liability_provider';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const create = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const context = apiRequest.getContext();
    const liabilities = apiRequest.parseEntity('liability', LiabilityEntity.parse);

    const expenseProvider = new LiabilityProvider(firestore, selector, context.gameId);
    const createdLiability = await expenseProvider.addLiability(context.userId, liabilities);

    response.status(200).send(createdLiability);
  });

  const getAll = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);
    const context = apiRequest.getContext();

    const liabilityProvider = new LiabilityProvider(firestore, selector, context.gameId);
    const liabilities = await liabilityProvider.getAllLiabilities(context.userId);

    response.status(200).send(liabilities);
  });

  return { create, getAll };
};
