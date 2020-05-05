import * as functions from 'firebase-functions';
import * as config from '../config';

import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { PossessionStateGenerator } from '../services/possession_state_generator';
import { GameProvider } from '../providers/game_provider';
import { GameContextEntity } from '../models/domain/game/game_context';
import { APIRequest } from '../core/api/request_data';
import produce from 'immer';

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
      const possisionState = possessionService.generateParticipantsPossessionState(game);

      const updatedGame = produce(game, (draft) => {
        draft.possessionState = possisionState;
      });

      await gameProvider.updateGame(updatedGame);

      return possisionState;
    };

    const possisionState = updatePossessionState();
    response.status(200).send(possisionState);
  });

  return { updatePossessionsState };
};
