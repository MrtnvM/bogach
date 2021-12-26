import * as express from 'express';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { DAOs } from '../dao/daos';
import { MultiplayerService } from '../services/multiplayer/multiplayer_service';

export const initialize = (daos: DAOs, app: express.Express) => {
  const userProvider = new UserProvider(daos.user);
  const multiplayerService = new MultiplayerService(userProvider);

  app.post(
    '/setOnlineStatus',
    APIRequest.handle(async (apiRequest) => {
      const userId = apiRequest.jsonField('userId');
      const fullName = apiRequest.jsonField('fullName');
      const avatarUrl = apiRequest.jsonField('avatarUrl');

      await multiplayerService.setOnlineStatus(userId, fullName, avatarUrl);
    })
  );

  app.get(
    '/getOnlineProfiles',
    APIRequest.handle(async (apiRequest) => {
      const userId = apiRequest.queryParameter('user_id');

      const profiles = await multiplayerService.getOnlineProfiles(userId);
      return profiles;
    })
  );
};
