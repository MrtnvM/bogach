/// <reference types="@types/jest"/>

import produce from 'immer';
import { mock, when, instance, anything, reset, capture, verify } from 'ts-mockito';

import { GameProvider } from './game_provider';
import { GameEntity } from '../models/domain/game/game';
import { GameTemplateFixture } from '../core/fixtures/game_template_fixture';
import { UserFixture } from '../core/fixtures/user_fixture';
import { GameTemplatesProvider } from './game_templates_provider';
import { FirestoreGameDAO } from '../dao/firestore/firestore_game_dao';
import { FirestoreRoomDAO } from '../dao/firestore/firestore_room_dao';
import { FirestoreUserDAO } from '../dao/firestore/firestore_user_dao';
import { LastGamesEntity } from '../models/domain/user/last_games';
import { User } from '../models/domain/user/user';
import { QuestFixture } from '../core/fixtures/quest_fixture';

describe('Game Provider', () => {
  const mockGameDao = mock(FirestoreGameDAO);
  const mockUserDao = mock(FirestoreUserDAO);
  const mockRoomDao = mock(FirestoreRoomDAO);
  const mockTemplateProvider = mock(GameTemplatesProvider);

  let gameProvider: GameProvider;

  beforeEach(() => {
    reset(mockGameDao);
    reset(mockUserDao);
    reset(mockRoomDao);
    reset(mockTemplateProvider);

    gameProvider = new GameProvider(
      instance(mockGameDao),
      instance(mockRoomDao),
      instance(mockUserDao),
      instance(mockTemplateProvider)
    );
  });

  test('Could not create game without participants IDs array', async () => {
    const templateId = 'template1';

    const createGame = async (participantsIds: any) => {
      await gameProvider.createGame(templateId, participantsIds);
    };

    await expect(createGame(undefined)).rejects.toThrow(
      new Error('ERROR: No participants IDs on game creation')
    );

    await expect(createGame(null)).rejects.toThrow(
      new Error('ERROR: No participants IDs on game creation')
    );

    await expect(createGame([])).rejects.toThrow(
      new Error('ERROR: No participants IDs on game creation')
    );
  });

  test('Could not create game without template', async () => {
    const templateId = 'template1';
    const participantsIds = ['user1'];

    const createGame = async () => {
      await gameProvider.createGame(templateId, participantsIds);
    };

    await expect(createGame()).rejects.toThrow(
      new Error('ERROR: No template with id: ' + templateId)
    );
  });

  test('Created game contains initial month result', async () => {
    const templateId = 'template12';
    const userId = 'user1';

    const gameTemplate = GameTemplateFixture.createGameTemplate({ id: templateId });

    when(mockTemplateProvider.getGameTemplate(templateId)).thenReturn(gameTemplate);
    when(mockGameDao.createGame(anything())).thenCall((game) => Promise.resolve(game));

    const createdGame = await gameProvider.createGame(templateId, [userId]);
    const monthResults = createdGame.state.participantsProgress[userId].monthResults;

    const expectedMonthResult: GameEntity.MonthResult = {
      cash: createdGame.accounts[userId].cash,
      totalIncome: 109_026.66666666667,
      totalExpense: 45_500,
      totalAssets: 2_295_000,
      totalLiabilities: 2_045_000,
    };

    const expectedMonthResults: { [month: number]: GameEntity.MonthResult } = {
      [0]: expectedMonthResult,
    };

    expect(monthResults).toStrictEqual(expectedMonthResults);
  });

  test('Successfully updated last singleplayer game', async () => {
    const templateId = 'template1';
    const userId = 'user1';

    const gameTemplate = GameTemplateFixture.createGameTemplate({ id: templateId });
    const user = UserFixture.createUser({ userId });

    when(mockTemplateProvider.getGameTemplate(templateId)).thenReturn(gameTemplate);
    when(mockGameDao.createGame(anything())).thenCall((game) => Promise.resolve(game));

    /// CASE 1: No existing last game in the user profile
    when(mockUserDao.getUser(userId)).thenResolve(user);
    const game1 = await gameProvider.createGame(templateId, [userId]);
    const [user1] = capture(mockUserDao.updateUserProfile).last();

    const expectedLastGames1 = produce(LastGamesEntity.initial(), (draft) => {
      draft.singleplayerGames = [{ gameId: game1.id, templateId, createdAt: game1.createdAt }];
    });
    expect(user1.lastGames).toStrictEqual(expectedLastGames1);
    verify(mockGameDao.deleteGame(anything())).never();

    /// CASE 2: There is a last game in the user profile
    when(mockUserDao.getUser(userId)).thenResolve(user1);
    const game2 = await gameProvider.createGame(templateId, [userId]);
    const [user2] = capture(mockUserDao.updateUserProfile).last();

    const expectedLastGames2 = produce(LastGamesEntity.initial(), (draft) => {
      draft.singleplayerGames = [{ gameId: game2.id, templateId, createdAt: game2.createdAt }];
    });
    expect(user2.lastGames).toStrictEqual(expectedLastGames2);
    verify(mockGameDao.deleteGame(game1.id)).once();
  });

  test('Successfully updated last quest game', async () => {
    const templateId = 'template1';
    const userId = 'user1';

    const gameTemplate = GameTemplateFixture.createGameTemplate({ id: templateId });
    const user = UserFixture.createUser({ userId });
    const quest = QuestFixture.createQuest();

    when(mockTemplateProvider.getGameTemplate(templateId)).thenReturn(gameTemplate);
    when(mockGameDao.createGame(anything())).thenCall((game) => Promise.resolve(game));

    /// CASE 1: No existing last game in the user profile
    when(mockUserDao.getUser(userId)).thenResolve(user);
    const game1 = await gameProvider.createGameByTemplate(gameTemplate, [userId], quest);
    const [user1] = capture(mockUserDao.updateUserProfile).last();

    const expectedLastGames1 = produce(LastGamesEntity.initial(), (draft) => {
      draft.questGames = [{ gameId: game1.id, templateId, createdAt: game1.createdAt }];
    });
    expect(user1.lastGames).toStrictEqual(expectedLastGames1);
    verify(mockGameDao.deleteGame(anything())).never();

    /// CASE 2: There is a last game in the user profile
    when(mockUserDao.getUser(userId)).thenResolve(user1);
    const game2 = await gameProvider.createGameByTemplate(gameTemplate, [userId], quest);
    const [user2] = capture(mockUserDao.updateUserProfile).last();

    const expectedLastGames2 = produce(LastGamesEntity.initial(), (draft) => {
      draft.questGames = [{ gameId: game2.id, templateId, createdAt: game2.createdAt }];
    });
    expect(user2.lastGames).toStrictEqual(expectedLastGames2);
    verify(mockGameDao.deleteGame(game1.id)).once();
  });

  test('Successfully updated last multiplayer game', async () => {
    const templateId = 'template1';
    const userId1 = 'user1';
    const userId2 = 'user2';

    const gameTemplate = GameTemplateFixture.createGameTemplate({ id: templateId });
    const firstUser = UserFixture.createUser({ userId: userId1 });
    const secondUser = UserFixture.createUser({ userId: userId2 });

    when(mockTemplateProvider.getGameTemplate(templateId)).thenReturn(gameTemplate);
    when(mockGameDao.createGame(anything())).thenCall((game) => Promise.resolve(game));

    /// CASE 1: No existing last game in the user profile
    when(mockUserDao.getUser(anything())).thenResolve(firstUser, secondUser);
    const game1 = await gameProvider.createGame(templateId, [userId1, userId2]);
    const [firstUser1] = capture<User, User>(mockUserDao.updateUserProfile).first();
    const [secondUser1] = capture<User, User>(mockUserDao.updateUserProfile).second();

    const expectedLastGames1 = produce(LastGamesEntity.initial(), (draft) => {
      draft.multiplayerGames = [{ gameId: game1.id, templateId, createdAt: game1.createdAt }];
    });
    expect([firstUser1.lastGames, secondUser1.lastGames]).toStrictEqual([
      expectedLastGames1,
      expectedLastGames1,
    ]);
    verify(mockGameDao.deleteGame(anything())).never();

    /// CASE 2: There is a last game in the user profile
    when(mockUserDao.getUser(anything())).thenResolve(firstUser1, secondUser1);
    const game2 = await gameProvider.createGame(templateId, [userId1, userId2]);
    const [firstUser2] = capture<User, User>(mockUserDao.updateUserProfile).beforeLast();
    const [secondUser2] = capture<User, User>(mockUserDao.updateUserProfile).last();

    const expectedLastGames2 = produce(LastGamesEntity.initial(), (draft) => {
      draft.multiplayerGames = [{ gameId: game2.id, templateId, createdAt: game2.createdAt }];
    });
    expect([firstUser2.lastGames, secondUser2.lastGames]).toStrictEqual([
      expectedLastGames2,
      expectedLastGames2,
    ]);
    verify(mockGameDao.deleteGame(game1.id)).twice();
  });
});
