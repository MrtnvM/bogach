import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { GameService } from '../services/game_service';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { PossessionService } from '../services/possession_service';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const createGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const templateId = apiRequest.jsonField('templateId');
    const userId = apiRequest.jsonField('userId');

    const gameProvider = new GameProvider(firestore, selector);
    const createdGame = await gameProvider.createGame(templateId, userId);

    const gameService = new GameService(gameProvider);

    const gameWithEvents = gameService.updateGameEvents(createdGame.id);
    return send(gameWithEvents, response);
  });

  const getAllGames = https.onRequest(async (request, response) => {
    const gameProvider = new GameProvider(firestore, selector);
    const games = gameProvider.getAllGames();

    return send(games, response);
  });

  const getGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const gameId = apiRequest.queryParameter('game_id');

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

    const templateId = apiRequest.queryParameter('template_id');

    const gameProvider = new GameProvider(firestore, selector);
    const gameTemplate = gameProvider.getGameTemplate(templateId);

    return send(gameTemplate, response);
  });

  const generateGameEvents = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const gameId = apiRequest.queryParameter('game_id');

    const gameProvider = new GameProvider(firestore, selector);
    const gameService = new GameService(gameProvider);
    const game = gameService.updateGameEvents(gameId);

    return send(game, response);
  });

  const handleGameEvent = https.onRequest(async (request, response) => {
    if (request.method !== 'POST') {
      response.status(400).send('ERROR: Required should use POST method');
      return;
    }

    const apiRequest = APIRequest.from(request);

    const action = apiRequest.jsonField('action');
    const context = apiRequest.jsonField('context');
    const eventId = apiRequest.jsonField('eventId');

    const gameProvider = new GameProvider(firestore, selector);
    const gameService = new GameService(gameProvider);

    const handleEvent = gameService
      .handlePlayerAction(eventId, action, context)
      .then(() => {
        const possessionService = new PossessionService(gameProvider);
        return possessionService.updatePossessionState(context);
      })
      .then(() => 'Player action handled');

    return send(handleEvent, response);
  });

  const send = <T>(data: Promise<T>, response: functions.Response) => {
    return data
      .then((result) => response.status(200).send(result))
      .catch((error) => {
        const errorMessage = error['message'] ? error.message : error;
        response.status(422).send(errorMessage);
      });
  };

  return {
    create: createGame,
    getAllGames,
    getGame,
    getAllGameTemplates,
    getGameTemplate,
    generateGameEvents,
    handleGameEvent,
  };
};
