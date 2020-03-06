import * as functions from 'firebase-functions';
import * as config from '../config';
import * as apiUtils from '../utils/api';

import { IncomeProvider } from '../providers/income_provider';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { PossessionService } from '../services/possession_service';
import { ExpenseProvider } from '../providers/expense_provider';
import { AssetProvider } from '../providers/asset_provider';
import { LiabilityProvider } from '../providers/liability_provider';
import { PossessionStateProvider } from '../providers/possession_state_provider';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const updatePossessionsState = https.onRequest(async (request, response) => {
    const jsonField = apiUtils.jsonBodyField(request);

    const userId = jsonField('user_id');
    const gameId = jsonField('game_id');

    const incomeProvider = new IncomeProvider(firestore, selector, gameId);
    const expenseProvider = new ExpenseProvider(firestore, selector, gameId);
    const assetProvider = new AssetProvider(firestore, selector, gameId);
    const liabilityProvider = new LiabilityProvider(firestore, selector, gameId);
    const possessionStateProvider = new PossessionStateProvider(firestore, selector, gameId);

    const possessionService = new PossessionService(
      incomeProvider,
      expenseProvider,
      assetProvider,
      liabilityProvider,
      possessionStateProvider
    );

    const state = await possessionService.updatePossessionState(userId);
    response.status(200).send(state);
  });

  return { updatePossessionsState };
};
