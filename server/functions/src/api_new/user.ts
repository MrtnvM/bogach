import * as express from 'express';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { UserService } from '../services/user/user_service';
import { UserEntity } from '../models/domain/user/user';
import { DAOs } from '../dao/daos';
import { FirebaseMessaging } from '../core/firebase/firebase_messaging';
import { sendResponse } from '../core/api/send_response';

export const initialize = (daos: DAOs, app: express.Express) => {
  const userProvider = new UserProvider(daos.user);
  const firebaseMessaging = new FirebaseMessaging();
  const userService = new UserService(userProvider, firebaseMessaging);

  app.get('/getUserProfile', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const userId = apiRequest.queryParameter('userId');
    const userProfile = userProvider.getUserProfile(userId as UserEntity.Id);

    await sendResponse(userProfile, response);
  });

  app.post('/addFriends', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const addFriendsExecution = async () => {
      const userId = apiRequest.jsonField('userId');
      const usersAddToFriendsKey = 'usersAddToFriends';
      const usersAddToFriends = apiRequest.jsonField(usersAddToFriendsKey);

      if (!Array.isArray(usersAddToFriends)) {
        throw new Error(usersAddToFriendsKey + ' should be array');
      }

      await userService.addFriends({ userId, usersAddToFriends });
    };

    await sendResponse(addFriendsExecution(), response);
  });

  app.delete('/removeFromFriends', async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('DELETE');

    const userId = apiRequest.jsonField('userId');
    const removedFriendId = apiRequest.jsonField('removedFriendId');

    const result = userService.removeFromFriends({ userId, removedFriendId });
    await sendResponse(result, response);
  });
};
