import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { GameService } from '../services/game_service';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { UserEntity } from '../models/domain/user';
import { GameTemplateEntity } from '../models/domain/game/game_template';
import { GameEntity } from '../models/domain/game/game';
import { UserProvider } from '../providers/user_provider';
import { scheduleMonthEndTimer } from './external/timer';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameProvider = new GameProvider(firestore, selector);
  const gameLevelsProvider = new GameLevelsProvider();
  const userProvider = new UserProvider(firestore, selector);
  const gameService = new GameService(gameProvider, gameLevelsProvider, userProvider);

  const createGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const templateId = apiRequest.jsonField('templateId');
    const participantsIds = apiRequest.optionalJsonField('participantsIds');
    const userId = apiRequest.optionalJsonField('userId');

    const game = gameService.createNewGame(templateId, participantsIds || [userId]);
    await send(game, response);
  });

  const getAllGames = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const games = gameProvider.getAllGames();

    await send(games, response);
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

    const gameTemplates = gameProvider.getAllGameTemplates();
    await send(gameTemplates, response);
  });

  const getGameTemplate = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const templateId = apiRequest.queryParameter('template_id');

    const gameTemplate = gameProvider.getGameTemplate(templateId as GameTemplateEntity.Id);
    await send(gameTemplate, response);
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
      const result = await gameService.startNewMonth(context);

      if (result) {
        const { game, isAllParticipantsCompletedMonth } = result;
        const shouldStartTimer = isAllParticipantsCompletedMonth && game.type === 'multiplayer';

        if (shouldStartTimer) {
          await scheduleMonthEndTimer({
            startDate: new Date(),
            gameId: game.id,
            monthNumber: game.state.monthNumber,
          });
        }
      }

      return 'New month started';
    };

    await send(startNewMonthRequest(), response);
  });

  const getGameLevels = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const userId = apiRequest.queryParameter('user_id');

    const gameLevels = gameLevelsProvider.getGameLevels();
    console.log(gameLevels.toString());
    const levelsIds = gameLevels.map((l) => l.id);
    const userQuestGames = await gameProvider.getUserQuestGames(userId as UserEntity.Id, levelsIds);

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

    await send(Promise.resolve(levelsInfo), response);
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
