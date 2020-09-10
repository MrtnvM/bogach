/// <reference types="@types/jest"/>

import { produce } from 'immer';
import { mock, instance, when, capture, anything, verify } from 'ts-mockito';

import { UserProvider } from '../providers/user_provider';
import { PurchaseService } from './purchase_service';
import { User } from '../models/domain/user';
import { Purchases } from '../core/purchases/purchases';

describe('Purchase Service', () => {
  test('Successfully update quests access', async () => {
    const userId = 'user1';
    const initialProfile: User = {
      userId,
      userName: 'John Dow',
      boughtQuestsAccess: undefined,
    };

    const mockUserProvider = mock(UserProvider);
    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);

    const userProvider = instance(mockUserProvider);
    const userService = new PurchaseService(userProvider);

    await userService.updatePurchases(userId, []);
    verify(mockUserProvider.updateUserProfile(anything())).never();

    await userService.updatePurchases(userId, ['some_product_id']);
    const expectedProfile2 = produce(initialProfile, (draft) => {
      draft.boughtQuestsAccess = false;
    });

    const [newUserProfile2] = capture(mockUserProvider.updateUserProfile).last();
    expect(expectedProfile2).toStrictEqual(newUserProfile2);

    await userService.updatePurchases(userId, [Purchases.questsAccessProductId]);
    const expectedProfile3 = produce(initialProfile, (draft) => {
      draft.boughtQuestsAccess = true;
    });

    const [newUserProfile3] = capture(mockUserProvider.updateUserProfile).last();
    expect(expectedProfile3).toStrictEqual(newUserProfile3);
  });
});
