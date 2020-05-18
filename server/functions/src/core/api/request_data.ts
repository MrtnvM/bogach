import * as functions from 'firebase-functions';
import * as apiUtils from '../../utils/api';
import { GameContextEntity, GameContext } from '../../models/domain/game/game_context';

export namespace APIRequest {
  export const from = (request: functions.https.Request) => {
    const jsonField = apiUtils.jsonBodyField(request);
    const optionalJsonField = apiUtils.optionalJsonBodyField(request);
    const queryParameter = apiUtils.queryParams(request);

    const getContext = () => {
      let gameContext: GameContext;

      if (request.method.toUpperCase() === 'GET') {
        gameContext = { gameId: queryParameter('game_id'), userId: queryParameter('user_id') };
      } else {
        gameContext = jsonField('context');
      }

      return GameContextEntity.parse(gameContext);
    };

    const parseEntity = <T>(jsonFieldName: string, parser: (data: any) => T) => {
      const entity = parser(jsonField(jsonFieldName));
      return entity;
    };

    return { getContext, parseEntity, jsonField, optionalJsonField, queryParameter };
  };
}
