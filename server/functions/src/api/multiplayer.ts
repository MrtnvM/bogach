import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { DAOs } from '../dao/daos';
import { MultiplayerService } from '../services/multiplayer/multiplayer_service';

export const create = (daos: DAOs) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const userProvider = new UserProvider(daos.user);
  const multiplayerService = new MultiplayerService(userProvider);

  const setOnlineStatus = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const userId = apiRequest.jsonField('userId');
    const fullName = apiRequest.jsonField('fullName');
    const avatarUrl = apiRequest.jsonField('avatarUrl');

    const status = multiplayerService.setOnlineStatus(userId, fullName, avatarUrl);

    await send(status, response);
  });

  const getOnlineProfiles = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const userId = apiRequest.queryParameter('user_id');

    const profiles = multiplayerService.getOnlineProfiles(userId);
    await send(profiles, response);
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
    getOnlineProfiles,
    setOnlineStatus,
  };
};
