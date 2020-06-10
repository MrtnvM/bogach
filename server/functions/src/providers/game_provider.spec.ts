/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { mock, when, instance, anything } from 'ts-mockito';

import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { GameProvider } from './game_provider';
import { GameEntity } from '../models/domain/game/game';
import { GameTemplateFixture } from '../core/fixtures/game_template_fixture';

describe('Game Provider', () => {
  test('Could not create game without participants IDs array', async () => {
    const mockFirestore: Firestore = mock(Firestore);
    const mockSelector: FirestoreSelector = mock(FirestoreSelector);
    const gameProvider = new GameProvider(mockFirestore, mockSelector);

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
    const mockFirestore = mock(Firestore);
    const mockSelector = mock(FirestoreSelector);
    const mockTemplateRef = mock(admin.firestore.DocumentReference);

    const templateId = 'template1';
    const participantsIds = ['user1'];

    when(mockSelector.gameTemplate(templateId)).thenReturn(mockTemplateRef);
    when(mockFirestore.getItemData(mockTemplateRef)).thenReturn(Promise.resolve(undefined));

    const firestore = instance(mockFirestore);
    const selector = instance(mockSelector);
    const gameProvider = new GameProvider(firestore, selector);

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
    const mockTemplateRef = mock(admin.firestore.DocumentReference);

    const templateId = 'template1';
    const userId = 'user1';

    const gameTemplate = GameTemplateFixture.createGameTemplate({ id: templateId });

    when(mockSelector.gameTemplate(templateId)).thenReturn(mockTemplateRef);
    when(mockFirestore.getItemData(mockTemplateRef)).thenReturn(Promise.resolve(gameTemplate));
    when(mockFirestore.createItem(anything(), anything())).thenCall((_, game) => {
      return game;
    });

    const firestore = instance(mockFirestore);
    const selector = instance(mockSelector);
    const gameProvider = new GameProvider(firestore, selector);

    const createdGame = await gameProvider.createGame(templateId, [userId]);
    const monthResults = createdGame.state.participantsProgress[userId].monthResults;

    const expectedMonthResult: GameEntity.MonthResult = {
      cash: createdGame.accounts[userId].cash,
      totalIncome: 109_320,
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
