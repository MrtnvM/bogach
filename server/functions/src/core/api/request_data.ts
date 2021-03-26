import * as functions from 'firebase-functions';
import * as apiUtils from '../../utils/api';
import { GameContextEntity, GameContext } from '../../models/domain/game/game_context';
import { GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';

export namespace APIRequest {
  export const from = (request: functions.https.Request, response: functions.Response) => {
    const jsonField = apiUtils.jsonBodyField(request);
    const optionalJsonField = apiUtils.optionalJsonBodyField(request);
    const queryParameter = apiUtils.queryParams(request);

    const getContext = () => {
      let gameContext: GameContext;

      if (request.method.toUpperCase() === 'GET') {
        gameContext = {
          gameId: queryParameter('game_id') as GameEntity.Id,
          userId: queryParameter('user_id') as UserEntity.Id,
        };
      } else {
        gameContext = jsonField('context');
      }

      return GameContextEntity.parse(gameContext);
    };

    const parseEntity = <T>(jsonFieldName: string, parser: (data: any) => T) => {
      const entity = parser(jsonField(jsonFieldName));
      return entity;
    };

    const checkMethod = (method: 'GET' | 'POST' | 'PUT' | 'DELETE' | 'PATCH') => {
      if (request.method !== method) {
        const error = `ERROR: Request should use ${method} method`;
        response.status(400).send(error);
        throw error;
      }
    };

    return {
      getContext,
      parseEntity,
      jsonField,
      optionalJsonField,
      queryParameter,
      checkMethod,
    };
  };
}
