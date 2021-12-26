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

  app.post(
    '/createGame',
    APIRequest.handle(async (apiRequest) => {
      const templateId = apiRequest.jsonField('templateId');
      const participantsIds = apiRequest.optionalJsonField('participantsIds');

      const userId = apiRequest.optionalJsonField('userId');

      const game = await gameService.createNewGame(templateId, participantsIds || [userId]);
      return game;
    })
  );

  app.get(
    '/getGame',
    APIRequest.handle(async (apiRequest) => {
      const gameId = apiRequest.queryParameter('game_id');
      const game = await gameProvider.getGame(gameId as GameEntity.Id);
      return game;
    })
  );

  app.get(
    '/getAllGameTemplates',
    APIRequest.handle(async (apiRequest) => {
      const gameTemplates = gameTemplatesProvider.getGameTemplates();
      return gameTemplates;
    })
  );

  app.get(
    '/getGameTemplate',
    APIRequest.handle(async (apiRequest) => {
      const templateId = apiRequest.queryParameter('template_id');
      const gameTemplate = gameTemplatesProvider.getGameTemplate(
        templateId as GameTemplateEntity.Id
      );

      return gameTemplate;
    })
  );

  app.post(
    '/handleGameEvent',
    APIRequest.handle(async (apiRequest) => {
      const action = apiRequest.optionalJsonField('action');
      const context = apiRequest.jsonField('context');
      const eventId = apiRequest.jsonField('eventId');

      const handleEvent = await gameService
        .handlePlayerAction(eventId, action, context)
        .then(() => 'Player action handled');

      return handleEvent;
    })
  );

  app.post(
    '/startNewMonth',
    APIRequest.handle(async (apiRequest) => {
      const context = apiRequest.jsonField('context');
      await gameService.startNewMonth(context);
      return 'New month started';
    })
  );

  app.get(
    '/getGameLevels',
    APIRequest.handle(async (apiRequest) => {
      const gameLevels = gameLevelsProvider.getGameLevels();
      return gameLevels;
    })
  );

  app.post(
    '/createGameByLevel',
    APIRequest.handle(async (apiRequest) => {
      const gameLevelId = apiRequest.jsonField('gameLevelId');
      const userId = apiRequest.jsonField('userId');

      const newGame = await gameService.createNewGameByLevel(gameLevelId, [userId]);
      return newGame;
    })
  );
};
