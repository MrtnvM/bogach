import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { User, UserEntity } from '../models/domain/user/user';
import { DAOs } from '../dao/daos';
import { produce } from 'immer';

export const create = (daos: DAOs) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const userProvider = new UserProvider(daos.user);

  const getUserProfile = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('GET');

    const userId = apiRequest.queryParameter('userId');
    const userProfile = userProvider.getUserProfile(userId as UserEntity.Id);

    await send(userProfile, response);
  });

  const addFriend = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const firstUserId = apiRequest.jsonField('firstUserId');
    const secondUserId = apiRequest.jsonField('secondUserId');

    const firstUser = await userProvider.getUserProfile(firstUserId);
    const updatedFirstUser = _addFriendToUser(firstUser, secondUserId);
    await userProvider.updateUserProfile(updatedFirstUser);

    const secondUser = await userProvider.getUserProfile(secondUserId);
    const updatedSecondUser = _addFriendToUser(secondUser, firstUserId);
    await userProvider.updateUserProfile(updatedSecondUser);

    await send(Promise.resolve(), response);
  });

  const _addFriendToUser = (user: User, friendId: UserEntity.Id) => {
    return produce(user, (draft) => {
      if (!user.friends?.includes(friendId)) {
        const newFriends = user.friends;
        newFriends?.push(friendId);
        draft.friends = newFriends;
      }
    });
  };

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

  return { getUserProfile, addFriend };
};
