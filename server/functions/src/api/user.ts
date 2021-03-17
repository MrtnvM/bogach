import * as functions from 'firebase-functions';
import * as config from '../config';

import { APIRequest } from '../core/api/request_data';
import { UserProvider } from '../providers/user_provider';
import { UserEntity } from '../models/domain/user/user';
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

      await _addFriendsToUser(userId, usersAddToFriends);
      usersAddToFriends.forEach(async (userAddToFriend) => {
        await _addFriendsToUser(userAddToFriend, [userId]);
      });

    };

    await send(addFriendsExecution(), response);
  });

  const _addFriendsToUser = async (userId: UserEntity.Id, usersToAdd: string[]) => {
    const user = await userProvider.getUserProfile(userId);
    const updatedUser = produce(user, (draft) => {
      draft.friends = _updateFriendsList(user.friends || [], usersToAdd);
      return draft;
    });
    await userProvider.updateUserProfile(updatedUser);

    return;
  };

  const _updateFriendsList = (currentFriends: string[], usersToAdd: string[]): string[] => {
    usersToAdd.forEach((userToAdd) => {
      if (!currentFriends.includes(userToAdd)) {
        currentFriends.push(userToAdd);
      }
    });

    return currentFriends;
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

  return { getUserProfile, addFriends };
};
