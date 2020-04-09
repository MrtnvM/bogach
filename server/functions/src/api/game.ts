import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const createGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const templateId = apiRequest.jsonField('templateId');
    const userId = apiRequest.jsonField('userId');

    const gameProvider = new GameProvider(firestore, selector);
    const createdGame = gameProvider.createGame(templateId, userId);

    return send(createdGame, response);
  });

  const getAllGames = https.onRequest(async (request, response) => {
    const gameProvider = new GameProvider(firestore, selector);
    const games = gameProvider.getAllGames();

    return send(games, response);
  });

  const getGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const gameId = apiRequest.queryParameter('gameId');

    const gameProvider = new GameProvider(firestore, selector);
    const game = gameProvider.getGame(gameId);

    return send(game, response);
  });

  const getAllGameTemplates = https.onRequest(async (request, response) => {
    const gameProvider = new GameProvider(firestore, selector);
    const gameTemplates = gameProvider.getAllGameTemplates();

    return send(gameTemplates, response);
  });

  const getGameTemplate = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const templateId = apiRequest.queryParameter('templateId');

    const gameProvider = new GameProvider(firestore, selector);
    const gameTemplate = gameProvider.getGameTemplate(templateId);

    return send(gameTemplate, response);
  });

  const send = <T>(data: Promise<T>, response: functions.Response) => {
    return data
      .then((result) => response.status(200).send(result))
      .catch((error) => {
        const errorMessage = error['message'] ? error.message : error;
        response.status(500).send(errorMessage);
      });
  };

  return { create: createGame, getAllGames, getGame, getAllGameTemplates, getGameTemplate };
};
