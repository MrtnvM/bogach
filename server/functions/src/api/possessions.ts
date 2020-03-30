import * as functions from 'firebase-functions';
import * as config from '../config';

import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { PossessionService } from '../services/possession_service';
import { GameProvider } from '../providers/game_provider';
import { GameContextEntity } from '../models/domain/game/game_context';
import { APIRequest } from '../core/api/request_data';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const updatePossessionsState = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const context = apiRequest.getContext();
    GameContextEntity.validate(context);

    const gameProvider = new GameProvider(firestore, selector);
    const possessionService = new PossessionService(gameProvider);

    const state = await possessionService.updatePossessionState(context);
    response.status(200).send(state);
  });

  return { updatePossessionsState };
};
