import * as functions from 'firebase-functions';
import * as config from '../config';

import produce from 'immer';

import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { PossessionStateGenerator } from '../services/possession_state_generator';
import { GameProvider } from '../providers/game_provider';
import { GameContextEntity } from '../models/domain/game/game_context';
import { APIRequest } from '../core/api/request_data';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const updatePossessionsState = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const context = apiRequest.getContext();
    GameContextEntity.validate(context);

    const updatePossessionState = async () => {
      const gameProvider = new GameProvider(firestore, selector);
      const possessionService = new PossessionStateGenerator();

      const game = await gameProvider.getGame(context.gameId);
      const newPossessionState = possessionService.generateParticipantsPossessionState(game);

      const updatedGame = produce(game, (draft) => {
        draft.possessionState = newPossessionState;
      });

      await gameProvider.updateGame(updatedGame);

      return newPossessionState;
    };

    const possessionState = updatePossessionState();
    response.status(200).send(possessionState);
  });

  return { updatePossessionsState };
};
