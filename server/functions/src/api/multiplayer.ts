import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { DAOs } from '../dao/daos';
import { MultiplayerService } from '../services/multiplayer/multiplayer_service';
import { sendResponse } from '../core/api/send_response';

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

    await sendResponse(status, response);
  });

  const getOnlineProfiles = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const userId = apiRequest.queryParameter('user_id');

    const profiles = multiplayerService.getOnlineProfiles(userId);
    await sendResponse(profiles, response);
  });

  return {
    getOnlineProfiles,
    setOnlineStatus,
  };
};
