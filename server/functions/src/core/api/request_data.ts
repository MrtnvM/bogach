import * as functions from 'firebase-functions';
import * as apiUtils from '../../utils/api';
import { GameContextEntity } from '../../models/domain/game/game_context';

export namespace APIRequest {
  export const from = (request: functions.https.Request) => {
    const getContext = () => {
      let gameContext;

      if (request.method.toUpperCase() === 'GET') {
        gameContext = request.query;
      } else {
        const jsonField = apiUtils.jsonBodyField(request);
        gameContext = jsonField('context');
      }

      return GameContextEntity.parse(gameContext);
    };

    const parseEntity = <T>(jsonField: string, parser: (data: any) => T) => {
      const getJsonField = apiUtils.jsonBodyField(request);
      const entity = parser(getJsonField(jsonField));
      return entity;
    };

    return { getContext, parseEntity };
  };
}
