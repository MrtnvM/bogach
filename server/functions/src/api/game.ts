import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const create = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const templateId = apiRequest.jsonField('templateId');
    const userId = apiRequest.jsonField('userId');

    const gameProvider = new GameProvider(firestore, selector);
    const createdGame = await gameProvider.createGame(templateId, userId);

    response.status(200).send(createdGame);
  });

  const getAllGames = https.onRequest(async (request, response) => {
    const gameProvider = new GameProvider(firestore, selector);
    const games = await gameProvider.getAllGames();

    response.status(200).send(games);
  });

  const getGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const gameId = apiRequest.queryParameter('gameId');

    const gameProvider = new GameProvider(firestore, selector);
    const gameTemplates = await gameProvider.getGame(gameId);

    response.status(200).send(gameTemplates);
  });

  const getAllGameTemplates = https.onRequest(async (request, response) => {
    const gameProvider = new GameProvider(firestore, selector);
    const gameTemplates = await gameProvider.getAllGameTemplates();

    response.status(200).send(gameTemplates);
  });

  const getGameTemplate = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const templateId = apiRequest.queryParameter('templateId');

    const gameProvider = new GameProvider(firestore, selector);
    const gameTemplates = await gameProvider.getGameTemplate(templateId);

    response.status(200).send(gameTemplates);
  });

  return { create, getAllGames, getGame, getAllGameTemplates, getGameTemplate };
};
