/// <reference types="@types/jest"/>

import produce from 'immer';
import { mock, when, instance, anything, verify, reset } from 'ts-mockito';

import { User } from '../models/domain/user/user';
import { PurchaseProfileEntity } from '../models/purchases/purchase_profile';
import { UserProvider } from './user_provider';
import { PlayedGames } from '../models/domain/user/played_games';
import { FirestoreUserDAO } from '../dao/firestore/firestore_user_dao';

describe('User Provider - ', () => {
  const mockUserDao = mock(FirestoreUserDAO);
  const userDao = instance(mockUserDao);
  const userProvider = new UserProvider(userDao);

  beforeEach(() => {
    reset(mockUserDao);
  });

  test('No updates for actual version of profile', async () => {
    const userId = 'user1';
    const playedGameInfo: PlayedGames = {
      multiplayerGames: [],
    };
    const userProfile: User = {
      userId,
      userName: 'User Name',
      avatarUrl: '',
      currentQuestIndex: 1,
      multiplayerGamePlayed: 1,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      },
      profileVersion: 3,
      playedGames: playedGameInfo,
    };

    when(mockUserDao.getUser(userId)).thenReturn(Promise.resolve(userProfile));

    const receivedProfile = await userProvider.getUserProfile(userId);

    expect(receivedProfile).toEqual(userProfile);
    verify(mockUserDao.getUser(userId)).once();
    verify(mockUserDao.updateUserProfile(anything())).never();
  });

  test('Successful migration to actual version of profile', async () => {
    const playedGameInfo: PlayedGames = {
      multiplayerGames: [],
    };
    const userId = 'user1';
    const userProfile: User = {
      userId,
      userName: 'User Name',
      avatarUrl: '',
      currentQuestIndex: 1,
      playedGames: playedGameInfo,
    };

    when(mockUserDao.getUser(userId)).thenReturn(Promise.resolve(userProfile));

    const receivedProfile = await userProvider.getUserProfile(userId);

    const expectedProfile = produce(userProfile, (draft) => {
      draft.multiplayerGamePlayed = 0;
      draft.purchaseProfile = {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: PurchaseProfileEntity.initialMultiplayerGamesCount,
      };
      draft.profileVersion = 3;
    });

    expect(receivedProfile).toEqual(expectedProfile);
    verify(mockUserDao.getUser(userId)).once();
    verify(mockUserDao.updateUserProfile(anything())).once();
  });
});
