import * as express from 'express';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { UserService } from '../services/user/user_service';
import { UserEntity } from '../models/domain/user/user';
import { DAOs } from '../dao/daos';
import { FirebaseMessaging } from '../core/firebase/firebase_messaging';

export const initialize = (daos: DAOs, app: express.Express) => {
  const userProvider = new UserProvider(daos.user);
  const firebaseMessaging = new FirebaseMessaging();
  const userService = new UserService(userProvider, firebaseMessaging);

  app.get(
    '/getUserProfile',
    APIRequest.handle(async (apiRequest) => {
      const userId = apiRequest.queryParameter('userId');
      const userProfile = await userProvider.getUserProfile(userId as UserEntity.Id);

      return userProfile;
    })
  );

  app.post(
    '/addFriends',
    APIRequest.handle(async (apiRequest) => {
      const userId = apiRequest.jsonField('userId');
      const usersAddToFriendsKey = 'usersAddToFriends';
      const usersAddToFriends = apiRequest.jsonField(usersAddToFriendsKey);

      if (!Array.isArray(usersAddToFriends)) {
        throw new Error(usersAddToFriendsKey + ' should be array');
      }

      await userService.addFriends({ userId, usersAddToFriends });
    })
  );

  app.delete(
    '/removeFromFriends',
    APIRequest.handle(async (apiRequest) => {
      const userId = apiRequest.jsonField('userId');
      const removedFriendId = apiRequest.jsonField('removedFriendId');

      await userService.removeFromFriends({ userId, removedFriendId });
    })
  );
};
