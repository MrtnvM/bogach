import * as express from 'express';
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
import { sendResponse } from '../core/api/send_response';

export const initialize = (daos: DAOs, app: express.Express) => {
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

  app.post('/createGame', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const templateId = apiRequest.jsonField('templateId');
    const participantsIds = apiRequest.optionalJsonField('participantsIds');

    const userId = apiRequest.optionalJsonField('userId');

    const game = gameService.createNewGame(templateId, participantsIds || [userId]);

    await sendResponse(game, response);
  });

  app.get('/getGame', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameId = apiRequest.queryParameter('game_id');

    const game = gameProvider.getGame(gameId as GameEntity.Id);
    await sendResponse(game, response);
  });

  app.get('/getAllGameTemplates', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameTemplates = gameTemplatesProvider.getGameTemplates();
    await sendResponse(Promise.resolve(gameTemplates), response);
  });

  app.get('/getGameTemplate', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const templateId = apiRequest.queryParameter('template_id');

    const gameTemplate = gameTemplatesProvider.getGameTemplate(templateId as GameTemplateEntity.Id);
    await sendResponse(Promise.resolve(gameTemplate), response);
  });

  app.post('/handleGameEvent', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const action = apiRequest.optionalJsonField('action');
    const context = apiRequest.jsonField('context');
    const eventId = apiRequest.jsonField('eventId');

    const handleEvent = gameService
      .handlePlayerAction(eventId, action, context)
      .then(() => 'Player action handled');

    await sendResponse(handleEvent, response);
  });

  app.post('/startNewMonth', async (request, response) => {
    console.log('Request : ' + JSON.stringify(request.body));

    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const context = apiRequest.jsonField('context');

    const startNewMonthRequest = async () => {
      await gameService.startNewMonth(context);
      return 'New month started';
    };

    await sendResponse(startNewMonthRequest(), response);
  });

  app.get('/getGameLevels', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const gameLevels = gameLevelsProvider.getGameLevels();
    await sendResponse(Promise.resolve(gameLevels), response);
  });

  app.post('/createGameByLevel', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const gameLevelId = apiRequest.jsonField('gameLevelId');
    const userId = apiRequest.jsonField('userId');

    const newGame = gameService.createNewGameByLevel(gameLevelId, [userId]);
    await sendResponse(newGame, response);
  });
};
