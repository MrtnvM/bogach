import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { GameService } from '../services/game_service';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameProvider = new GameProvider(firestore, selector);
  const gameService = new GameService(gameProvider);

  const createGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const templateId = apiRequest.jsonField('templateId');
    const participantsIds = apiRequest.optionalJsonField('participantsIds');
    const userId = apiRequest.optionalJsonField('userId');

    const game = gameService.createNewGame(templateId, participantsIds || [userId]);
    return send(game, response);
  });

  const getAllGames = https.onRequest(async (request, response) => {
    const games = gameProvider.getAllGames();

    return send(games, response);
  });

  const getGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const gameId = apiRequest.queryParameter('game_id');

    const game = gameProvider.getGame(gameId);
    return send(game, response);
  });

  const getAllGameTemplates = https.onRequest(async (request, response) => {
    const gameTemplates = gameProvider.getAllGameTemplates();
    return send(gameTemplates, response);
  });

  const getGameTemplate = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request);

    const templateId = apiRequest.queryParameter('template_id');

    const gameTemplate = gameProvider.getGameTemplate(templateId);
    return send(gameTemplate, response);
  });

  const handleGameEvent = https.onRequest(async (request, response) => {
    if (request.method !== 'POST') {
      response.status(400).send('ERROR: Required should use POST method');
      return;
    }

    const apiRequest = APIRequest.from(request);

    const action = apiRequest.optionalJsonField('action');
    const context = apiRequest.jsonField('context');
    const eventId = apiRequest.jsonField('eventId');

    const handleEvent = gameService
      .handlePlayerAction(eventId, action, context)
      .then(() => 'Player action handled');

    return send(handleEvent, response);
  });

  const startNewMonth = https.onRequest(async (request, response) => {
    if (request.method !== 'POST') {
      response.status(400).send('ERROR: Required should use POST method');
      return;
    }

    const apiRequest = APIRequest.from(request);
    const context = apiRequest.jsonField('context');

    const startNewMonthRequest = gameService.startNewMonth(context).then(() => 'New month started');

    return send(startNewMonthRequest, response);
  });

  const send = <T>(data: Promise<T>, response: functions.Response) => {
    return data
      .then((result) => response.status(200).send(result))
      .catch((error) => {
        const errorMessage = error['message'] ? error.message : error;
        console.error('ERROR: ' + JSON.stringify(error));
        console.error('ERROR MESSAGE: ' + errorMessage);
        response.status(422).send(errorMessage);
      });
  };

  return {
    create: createGame,
    getAllGames,
    getGame,
    getAllGameTemplates,
    getGameTemplate,
    handleGameEvent,
    startNewMonth,
  };
};
