import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { UserService } from '../services/user/user_service';
import { UserEntity } from '../models/domain/user/user';
import { DAOs } from '../dao/daos';
import { FirebaseMessaging } from '../core/firebase/firebase_messaging';

export const create = (daos: DAOs) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const userProvider = new UserProvider(daos.user);
  const firebaseMessaging = new FirebaseMessaging();
  const userService = new UserService(userProvider, firebaseMessaging);

  const getUserProfile = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const userId = apiRequest.queryParameter('userId');
    const userProfile = userProvider.getUserProfile(userId as UserEntity.Id);

    await send(userProfile, response);
  });

  const addFriends = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);

    const addFriendsExecution = async () => {
      apiRequest.checkMethod('POST');

      const userId = apiRequest.jsonField('userId');
      const usersAddToFriendsKey = 'usersAddToFriends';
      const usersAddToFriends = apiRequest.jsonField(usersAddToFriendsKey);

      if (!Array.isArray(usersAddToFriends)) {
        throw new Error(usersAddToFriendsKey + ' should be array');
      }

      await userService.addFriends({ userId, usersAddToFriends });
    };

    await send(addFriendsExecution(), response);
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

  return { getUserProfile, addFriends };
};
