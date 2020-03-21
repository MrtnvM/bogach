import * as functions from 'firebase-functions';
import * as apiUtils from '../../utils/api';
import { GameContextEntity } from '../../models/domain/game/game_context';

export namespace APIRequest {
  export const from = (request: functions.https.Request) => {
    const jsonField = apiUtils.jsonBodyField(request);
    const queryParameter = apiUtils.queryParams(request);

    const getContext = () => {
      let gameContext;

      if (request.method.toUpperCase() === 'GET') {
        gameContext = request.query;
      } else {
        gameContext = jsonField('context');
      }

      return GameContextEntity.parse(gameContext);
    };

    const parseEntity = <T>(jsonFieldName: string, parser: (data: any) => T) => {
      const entity = parser(jsonField(jsonFieldName));
      return entity;
    };

    return { getContext, parseEntity, jsonField, queryParameter };
  };
}
