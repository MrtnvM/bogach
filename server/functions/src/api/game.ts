import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { GameService } from '../services/game/game_service';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { APIRequest } from '../core/api/request_data';
import { GameTemplateEntity } from '../game_templates/models/game_template';
import { GameEntity } from '../models/domain/game/game';
import { UserProvider } from '../providers/user_provider';
import { TimerProvider } from '../providers/timer_provider';
import { GameTemplatesProvider } from '../providers/game_templates_provider';
import { DAOs } from '../dao/daos';

export const create = (daos: DAOs) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameLevelsProvider = new GameLevelsProvider();
  const gameTemplatesProvider = new GameTemplatesProvider();
  const gameProvider = new GameProvider(
    daos.game,
    daos.room,
    daos.user,
    daos.levelStatistic,
    gameTemplatesProvider
  );
  const userProvider = new UserProvider(daos.user);
  const timerProvider = new TimerProvider();

  const gameService = new GameService(
    gameProvider,
    gameLevelsProvider,
    userProvider,
    timerProvider
  );

  const createGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const templateId = apiRequest.jsonField('templateId');
    const participantsIds = apiRequest.optionalJsonField('participantsIds');

    const userId = apiRequest.optionalJsonField('userId');

    const game = gameService.createNewGame(templateId, participantsIds || [userId]);

    await send(game, response);
  });

  const getGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameId = apiRequest.queryParameter('game_id');

    const game = gameProvider.getGame(gameId as GameEntity.Id);
    await send(game, response);
  });

  const getAllGameTemplates = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameTemplates = gameTemplatesProvider.getGameTemplates();
    await send(Promise.resolve(gameTemplates), response);
  });

  const getGameTemplate = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const templateId = apiRequest.queryParameter('template_id');

    const gameTemplate = gameTemplatesProvider.getGameTemplate(templateId as GameTemplateEntity.Id);
    await send(Promise.resolve(gameTemplate), response);
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

    await send(handleEvent, response);
  });

  const startNewMonth = https.onRequest(async (request, response) => {
    console.log('Request : ' + JSON.stringify(request.body));

    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const context = apiRequest.jsonField('context');

    const startNewMonthRequest = async () => {
      await gameService.startNewMonth(context);
      return 'New month started';
    };

    await send(startNewMonthRequest(), response);
  });

  const getGameLevels = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameLevels = gameLevelsProvider.getGameLevels();
    await send(Promise.resolve(gameLevels), response);
  });

  const createGameByLevel = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const gameLevelId = apiRequest.jsonField('gameLevelId');
    const userId = apiRequest.jsonField('userId');

    const newGame = gameService.createNewGameByLevel(gameLevelId, [userId]);
    await send(newGame, response);
    return Promise.resolve();
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
    getGame,
    getAllGameTemplates,
    getGameTemplate,
    handleGameEvent,
    startNewMonth,
    getGameLevels,
    createGameByLevel,
  };
};
