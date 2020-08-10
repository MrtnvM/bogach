import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { GameService } from '../services/game_service';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameProvider = new GameProvider(firestore, selector);
  const gameLevelsProvider = new GameLevelsProvider();
  const gameService = new GameService(gameProvider, gameLevelsProvider);

  const createGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const templateId = apiRequest.jsonField('templateId');
    const participantsIds = apiRequest.optionalJsonField('participantsIds');
    const userId = apiRequest.optionalJsonField('userId');

    const game = gameService.createNewGame(templateId, participantsIds || [userId]);
    return send(game, response);
  });

  const getAllGames = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const games = gameProvider.getAllGames();

    return send(games, response);
  });

  const getGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameId = apiRequest.queryParameter('game_id');

    const game = gameProvider.getGame(gameId);
    return send(game, response);
  });

  const getAllGameTemplates = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameTemplates = gameProvider.getAllGameTemplates();
    return send(gameTemplates, response);
  });

  const getGameTemplate = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const templateId = apiRequest.queryParameter('template_id');

    const gameTemplate = gameProvider.getGameTemplate(templateId);
    return send(gameTemplate, response);
  });

  const handleGameEvent = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const action = apiRequest.optionalJsonField('action');
    const context = apiRequest.jsonField('context');
    const eventId = apiRequest.jsonField('eventId');

    const handleEvent = gameService
      .handlePlayerAction(eventId, action, context)
      .then(() => 'Player action handled');

    return send(handleEvent, response);
  });

  const startNewMonth = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const context = apiRequest.jsonField('context');

    const startNewMonthRequest = gameService.startNewMonth(context).then(() => 'New month started');

    return send(startNewMonthRequest, response);
  });

  const getGameLevels = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const userId = apiRequest.queryParameter('user_id');

    const gameLevels = gameLevelsProvider.getGameLevels();
    const levelsIds = gameLevels.map((l) => l.id);
    const userQuestGames = await gameProvider.getUserQuestGames(userId, levelsIds);

    const levelsInfo = gameLevels.map((level) => {
      const { id, name, description, icon } = level;
      const questGame = userQuestGames.find((g) => g.config.level === id);

      return {
        id,
        name,
        description,
        icon,
        currentGameId: questGame?.id,
      };
    });

    return send(Promise.resolve(levelsInfo), response);
  });

  const createGameByLevel = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const gameLevelId = apiRequest.jsonField('gameLevelId');
    const userId = apiRequest.jsonField('userId');

    try {
      await gameProvider.removeUserQuestGamesForLevel(userId, gameLevelId);
    } catch (error) {
      console.error(error);
    }

    const newGame = gameService.createNewGameByLevel(gameLevelId, [userId]);
    return send(newGame, response);
  });

  const send = <T>(data: Promise<T>, response: functions.Response) => {
    return data
      .then((result) => response.status(200).send(result))
      .catch((error) => {
        if (error['type'] === 'domain') {
          const json = JSON.stringify(error);
          response.status(422).send(json);
          return;
        }

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
    getGameLevels,
    createGameByLevel,
  };
};
