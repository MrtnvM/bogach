/// <reference types="@types/jest"/>

import { mock, when, instance, anything } from 'ts-mockito';

import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { GameProvider } from './game_provider';
import { GameEntity } from '../models/domain/game/game';
import { GameTemplateFixture } from '../core/fixtures/game_template_fixture';
import { GameTemplatesProvider } from './game_templates_provider';
import { FirestoreGameDAO } from '../dao/firestore/firestore_game_dao';
import { FirestoreRoomDAO } from '../dao/firestore/firestore_room_dao';
import { FirestoreUserDAO } from '../dao/firestore/firestore_user_dao';

describe('Game Provider', () => {
  test('Could not create game without participants IDs array', async () => {
    const mockFirestore: Firestore = mock(Firestore);
    const mockSelector: FirestoreSelector = mock(FirestoreSelector);
    const mockGameTemplatesProvider: GameTemplatesProvider = mock(GameTemplatesProvider);

    const gameDao = new FirestoreGameDAO(mockSelector, mockFirestore);
    const roomDao = new FirestoreRoomDAO(mockSelector, mockFirestore);
    const userDao = new FirestoreUserDAO(mockSelector, mockFirestore);

    const gameProvider = new GameProvider(gameDao, roomDao, userDao, mockGameTemplatesProvider);

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

    const mockFirestore = mock(Firestore);
    const mockSelector = mock(FirestoreSelector);
    const mockGameTemplatesProvider = mock(GameTemplatesProvider);

    const gameDao = new FirestoreGameDAO(mockSelector, mockFirestore);
    const roomDao = new FirestoreRoomDAO(mockSelector, mockFirestore);
    const userDao = new FirestoreUserDAO(mockSelector, mockFirestore);

    const gameProvider = new GameProvider(gameDao, roomDao, userDao, mockGameTemplatesProvider);

    const createGame = async () => {
      await gameProvider.createGame(templateId, participantsIds);
    };

    await expect(createGame()).rejects.toThrow(
      new Error('ERROR: No template with id: ' + templateId)
    );
  });

  test('Created game contains initial month result', async () => {
    const mockFirestore = mock(Firestore);
    const mockSelector = mock(FirestoreSelector);
    const mockGameTemplatesProvider = mock(GameTemplatesProvider);

    const templateId = 'template12';
    const userId = 'user1';

    const gameTemplate = GameTemplateFixture.createGameTemplate({ id: templateId });

    when(mockGameTemplatesProvider.getGameTemplate(templateId)).thenReturn(gameTemplate);
    when(mockFirestore.createItem(anything(), anything())).thenCall((_, game) => {
      return game;
    });

    const firestore = instance(mockFirestore);
    const selector = instance(mockSelector);
    const templateProvider = instance(mockGameTemplatesProvider);

    const gameDao = new FirestoreGameDAO(selector, firestore);
    const roomDao = new FirestoreRoomDAO(selector, firestore);
    const userDao = new FirestoreUserDAO(selector, firestore);

    const gameProvider = new GameProvider(gameDao, roomDao, userDao, templateProvider);

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
});
