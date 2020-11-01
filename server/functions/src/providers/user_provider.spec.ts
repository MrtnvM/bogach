/// <reference types="@types/jest"/>

import produce from 'immer';
import { mock, when, instance, anything, verify, reset, capture } from 'ts-mockito';

import { User } from '../models/domain/user/user';
import { PurchaseProfileEntity } from '../models/purchases/purchase_profile';
import { UserProvider } from './user_provider';
import { PlayedGames } from '../models/domain/user/played_games';
import { FirestoreUserDAO } from '../dao/firestore/firestore_user_dao';
import { LastGamesEntity } from '../models/domain/user/last_games';
import { UserFixture } from '../core/fixtures/user_fixture';

describe('User Provider', () => {
  const mockUserDao = mock(FirestoreUserDAO);

  let userProvider: UserProvider;

  beforeEach(() => {
    reset(mockUserDao);

    userProvider = new UserProvider(instance(mockUserDao));
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
      lastGames: LastGamesEntity.initial(),
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
      draft.lastGames = LastGamesEntity.initial();
    });

    expect(receivedProfile).toEqual(expectedProfile);
    verify(mockUserDao.getUser(userId)).once();
    verify(mockUserDao.updateUserProfile(anything())).once();
  });

  test('Successfully removed completed singleplayer game', async () => {
    const userId = 'user1';
    const gameId = 'game1';
    const templateId = 'template1';

    const user = UserFixture.createUser({
      userId,
      lastGames: {
        singleplayerGames: [{ gameId, templateId }],
        questGames: [],
        multiplayerGames: [],
      },
    });

    when(mockUserDao.getUser(userId)).thenResolve(user);
    await userProvider.removeGameFromLastGames(userId, gameId);

    const [newUser] = capture(mockUserDao.updateUserProfile).last();
    const expectedUser = produce(user, (draft) => {
      draft.lastGames = LastGamesEntity.initial();
    });
    expect(newUser).toStrictEqual(expectedUser);

    when(mockUserDao.getUser(userId)).thenResolve(newUser);
    await userProvider.removeGameFromLastGames(userId, gameId);

    verify(mockUserDao.getUser(userId)).twice();
    verify(mockUserDao.updateUserProfile(anything())).once();
  });

  test('Successfully removed completed quest game', async () => {
    const userId = 'user1';
    const gameId = 'game1';
    const templateId = 'template1';

    const user = UserFixture.createUser({
      userId,
      lastGames: {
        singleplayerGames: [],
        questGames: [{ gameId, templateId }],
        multiplayerGames: [],
      },
    });

    when(mockUserDao.getUser(userId)).thenResolve(user);
    await userProvider.removeGameFromLastGames(userId, gameId);

    const [newUser] = capture(mockUserDao.updateUserProfile).last();
    const expectedUser = produce(user, (draft) => {
      draft.lastGames = LastGamesEntity.initial();
    });
    expect(newUser).toStrictEqual(expectedUser);

    when(mockUserDao.getUser(userId)).thenResolve(newUser);
    await userProvider.removeGameFromLastGames(userId, gameId);

    verify(mockUserDao.getUser(userId)).twice();
    verify(mockUserDao.updateUserProfile(anything())).once();
  });

  test('Successfully removed completed quest game', async () => {
    const userId = 'user1';
    const gameId = 'game1';
    const templateId = 'template1';

    const user = UserFixture.createUser({
      userId,
      lastGames: {
        singleplayerGames: [],
        questGames: [],
        multiplayerGames: [{ gameId, templateId }],
      },
    });

    when(mockUserDao.getUser(userId)).thenResolve(user);
    await userProvider.removeGameFromLastGames(userId, gameId);

    const [newUser] = capture(mockUserDao.updateUserProfile).last();
    const expectedUser = produce(user, (draft) => {
      draft.lastGames = LastGamesEntity.initial();
    });
    expect(newUser).toStrictEqual(expectedUser);

    when(mockUserDao.getUser(userId)).thenResolve(newUser);
    await userProvider.removeGameFromLastGames(userId, gameId);

    verify(mockUserDao.getUser(userId)).twice();
    verify(mockUserDao.updateUserProfile(anything())).once();
  });
});
