/// <reference types="@types/jest"/>

import { mock, when, instance } from 'ts-mockito';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { GameProvider } from './game_provider';
import { MockDocumentSnapshot } from '../core/mock/mock_document_snapshot';
import * as admin from 'firebase-admin';

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

  // TODO(Maxim): Find out why firestore is undefined when method was mocked
  test.skip('Could not create game without template', async () => {
    const mockFirestore: Firestore = mock(Firestore);
    const mockSelector = mock(FirestoreSelector);
    const mockTemplateRef = mock(admin.firestore.DocumentReference);

    const templateId = 'template1';
    const participantsIds = ['user1'];

    when(mockSelector.gameTemplate(templateId)).thenReturn(mockTemplateRef);

    const getGameTemplate = async () => {
      return new MockDocumentSnapshot<FirebaseFirestore.DocumentData>({
        data: undefined,
      });
    };

    when(mockFirestore.getItem(mockTemplateRef)).thenReturn(getGameTemplate());

    const firestore = instance(mockFirestore);
    const selector = instance(mockSelector);
    const gameProvider = new GameProvider(firestore, selector);

    const createGame = async () => {
      await gameProvider.createGame(templateId, participantsIds);
    };

    await expect(createGame()).rejects.toThrow(new Error('ERROR: No template on game creation'));
  });
});
