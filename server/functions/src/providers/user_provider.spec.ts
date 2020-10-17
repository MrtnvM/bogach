/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import produce from 'immer';
import { mock, when, instance, anything, verify, reset } from 'ts-mockito';

import { Firestore } from '../core/firebase/firestore';
import { User } from '../models/domain/user';
import { PurchaseProfileEntity } from '../models/purchases/purchase_profile';
import { FirestoreSelector } from './firestore_selector';
import { UserProvider } from './user_provider';

describe('User Provider - ', () => {
  const mockFirestore = mock(Firestore);
  const mockSelector = mock(FirestoreSelector);
  const mockRef = mock(admin.firestore.DocumentReference);

  const firestore = instance(mockFirestore);
  const selector = instance(mockSelector);
  const userProvider = new UserProvider(firestore, selector);

  beforeEach(() => {
    reset(mockFirestore);
    reset(mockSelector);
    reset(mockRef);
  });

  test('No updates for actual version of profile', async () => {
    const userId = 'user1';
    const userProfile: User = {
      userId,
      userName: 'User Name',
      currentQuestIndex: 1,
      multiplayerGamePlayed: 1,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      },
      profileVersion: 2,
    };

    when(mockSelector.user(userId)).thenReturn(mockRef);
    when(mockFirestore.getItemData(mockRef)).thenReturn(Promise.resolve(userProfile));

    const receivedProfile = await userProvider.getUserProfile(userId);

    expect(receivedProfile).toEqual(userProfile);
    verify(mockFirestore.getItemData(anything())).once();
    verify(mockFirestore.updateItem(anything(), anything())).never();
  });

  test('Successful migration to actual version of profile', async () => {
    const userId = 'user1';
    const userProfile: User = {
      userId,
      userName: 'User Name',
      currentQuestIndex: 1,
    };

    when(mockSelector.user(userId)).thenReturn(mockRef);
    when(mockFirestore.getItemData(mockRef)).thenReturn(Promise.resolve(userProfile));

    const receivedProfile = await userProvider.getUserProfile(userId);

    const expectedProfile = produce(userProfile, (draft) => {
      draft.multiplayerGamePlayed = 0;
      draft.purchaseProfile = {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: PurchaseProfileEntity.initialMultiplayerGamesCount,
      };
      draft.profileVersion = 2;
    });

    expect(receivedProfile).toEqual(expectedProfile);
    verify(mockFirestore.getItemData(anything())).once();
    verify(mockFirestore.updateItem(anything(), anything())).once();
  });
});
