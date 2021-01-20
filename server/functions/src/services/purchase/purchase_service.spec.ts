/// <reference types="@types/jest"/>

import { produce } from 'immer';
import { mock, instance, when, capture, anything, verify, reset } from 'ts-mockito';

import { UserProvider } from '../../providers/user_provider';
import { PurchaseService } from './purchase_service';
import { User } from '../../models/domain/user/user';
import { Purchases } from '../../core/purchases/purchases';
import { TestData } from './purchase_service.spec.utils';
import { PurchaseProfileEntity } from '../../models/purchases/purchase_profile';
import { PlayedGameInfo } from '../../models/domain/user/player_game_info';
import { nowInUtc } from '../../utils/datetime';

describe('Purchase Service', () => {
  const mockUserProvider = mock(UserProvider);
  const userProvider = instance(mockUserProvider);
  const purchaseService = new PurchaseService(userProvider);

  beforeEach(() => {
    reset(mockUserProvider);
  });

  test('No actions if no purchases to update', async () => {
    const { userId } = TestData;

    await purchaseService.updatePurchases(userId, []);

    verify(mockUserProvider.getUserProfile(anything())).never();
    verify(mockUserProvider.addUserPurchases(anything(), anything())).never();
  });

  test('No purchase profile updates if product id is unknown', async () => {
    const { userId, getInitialProfile, getPurchase } = TestData;
    const initialProfile: User = getInitialProfile({
      boughtQuestsAccess: false,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      },
    });

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    const purchase = getPurchase({ productId: 'some_product_id' });
    await purchaseService.updatePurchases(userId, [purchase]);

    verify(mockUserProvider.updateUserProfile(anything())).never();
    verify(mockUserProvider.addUserPurchases(userId, [purchase]));
  });

  test('Successfully update quests access', async () => {
    const { userId, getInitialProfile, getPurchase } = TestData;
    const initialProfile: User = getInitialProfile({
      boughtQuestsAccess: undefined,
    });

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    const questsAccessPurchase = getPurchase({ productId: Purchases.questsAccessProductId });
    await purchaseService.updatePurchases(userId, [questsAccessPurchase]);

    const [newUserProfile] = capture(mockUserProvider.updateUserProfile).last();
    const expectedProfile = produce(initialProfile, (draft) => {
      draft.boughtQuestsAccess = true;
      draft.purchaseProfile = {
        isQuestsAvailable: true,
        boughtMultiplayerGamesCount: 3,
      };
    });

    expect(expectedProfile).toStrictEqual(newUserProfile);
    verify(mockUserProvider.updateUserProfile(newUserProfile)).once();
    verify(mockUserProvider.addUserPurchases(userId, [questsAccessPurchase]));
  });

  test('Successfully buy 1 multiplayer game', async () => {
    const { userId, getInitialProfile, getPurchase } = TestData;
    const initialProfile = getInitialProfile({
      boughtQuestsAccess: false,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      },
    });

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    const oneGamePurchase = getPurchase({ productId: Purchases.multiplayer1ProductId });
    await purchaseService.updatePurchases(userId, [oneGamePurchase]);

    const [newUserProfile] = capture(mockUserProvider.updateUserProfile).last();
    const expectedProfile = produce(initialProfile, (draft) => {
      draft.purchaseProfile!.boughtMultiplayerGamesCount = 4;
    });
    expect(expectedProfile).toStrictEqual(newUserProfile);
  });

  test('Successfully buy 5 + 1 multiplayer games', async () => {
    const { userId, getInitialProfile, getPurchase } = TestData;
    const initialProfile = getInitialProfile({
      boughtQuestsAccess: false,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      },
    });

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    const fiveGamePurchase = getPurchase({ productId: Purchases.multiplayer5ProductId });
    await purchaseService.updatePurchases(userId, [fiveGamePurchase]);

    const [newUserProfile] = capture(mockUserProvider.updateUserProfile).last();
    const expectedProfile = produce(initialProfile, (draft) => {
      draft.purchaseProfile!.boughtMultiplayerGamesCount = 9;
    });
    expect(expectedProfile).toStrictEqual(newUserProfile);
  });

  test('Successfully buy 10 + 2 multiplayer games', async () => {
    const { userId, getInitialProfile, getPurchase } = TestData;
    const initialProfile = getInitialProfile({
      boughtQuestsAccess: false,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      },
    });

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    const tenGamePurchase = getPurchase({ productId: Purchases.multiplayer10ProductId });
    await purchaseService.updatePurchases(userId, [tenGamePurchase]);

    const [newUserProfile] = capture(mockUserProvider.updateUserProfile).last();
    const expectedProfile = produce(initialProfile, (draft) => {
      draft.purchaseProfile!.boughtMultiplayerGamesCount = 15;
    });
    expect(expectedProfile).toStrictEqual(newUserProfile);
  });

  test('Successfully increasing played multiplayer games counter', async () => {
    const { userId, getInitialProfile } = TestData;
    const initialProfile = getInitialProfile({
      boughtQuestsAccess: false,
      multiplayerGamePlayed: 0,
    });
    const gameCreationDate = nowInUtc();

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    await purchaseService.reduceMultiplayerGames(
      [initialProfile.userId],
      'gameId',
      gameCreationDate
    );

    const [newUserProfile] = capture(mockUserProvider.updateUserProfile).last();
    const expectedProfile = produce(initialProfile, (draft) => {
      const playedGames = draft.playedGames || {
        multiplayerGames: [],
      };
      playedGames.multiplayerGames = [];

      const playedGameInfo: PlayedGameInfo = {
        gameId: 'gameId',
        createdAt: gameCreationDate,
      };
      playedGames.multiplayerGames.push(playedGameInfo);

      draft.playedGames = playedGames;
    });
    expect(expectedProfile).toStrictEqual(newUserProfile);
  });

  test('Reduce zero multiplayer games', async () => {
    const { userId, getInitialProfile } = TestData;
    const initialProfile = getInitialProfile({
      boughtQuestsAccess: false,
      multiplayerGamePlayed: 0,
      purchaseProfile: {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 0,
      },
    });

    when(mockUserProvider.getUserProfile(userId)).thenResolve(initialProfile);
    when(mockUserProvider.getUserPurchases(userId)).thenResolve([]);

    await expect(
      purchaseService.reduceMultiplayerGames([initialProfile.userId], 'gameId', nowInUtc())
    ).rejects.toThrow(/.*multiplayerGamesCount can't be less then zero.*/);
  });

  test('Calculation of purchase profile', () => {
    const { getPurchase, getPurchaseProfile } = TestData;
    const questPurchase = getPurchase({ productId: Purchases.questsAccessProductId });
    const oneMPGamePurchase = getPurchase({ productId: Purchases.multiplayer1ProductId });
    const fiveMPGamePurchase = getPurchase({ productId: Purchases.multiplayer5ProductId });
    const tenMPGamePurchase = getPurchase({ productId: Purchases.multiplayer10ProductId });
    const randomPurchase = getPurchase({ productId: 'random_purchase' });

    const profile1 = purchaseService.recalculatePurchaseProfile([]);
    expect(profile1).toEqual(PurchaseProfileEntity.initialPurchaseProfile);

    const profile2 = purchaseService.recalculatePurchaseProfile([questPurchase]);
    const expectedProfile2 = getPurchaseProfile({ isQuestsAvailable: true });
    expect(profile2).toEqual(expectedProfile2);

    const profile3 = purchaseService.recalculatePurchaseProfile([oneMPGamePurchase]);
    const expectedProfile3 = getPurchaseProfile({ boughtMultiplayerGamesCount: 4 });
    expect(profile3).toEqual(expectedProfile3);

    const profile4 = purchaseService.recalculatePurchaseProfile([fiveMPGamePurchase]);
    const expectedProfile4 = getPurchaseProfile({ boughtMultiplayerGamesCount: 9 });
    expect(profile4).toEqual(expectedProfile4);

    const profile5 = purchaseService.recalculatePurchaseProfile([tenMPGamePurchase]);
    const expectedProfile5 = getPurchaseProfile({ boughtMultiplayerGamesCount: 15 });
    expect(profile5).toEqual(expectedProfile5);

    const profile6 = purchaseService.recalculatePurchaseProfile([
      oneMPGamePurchase,
      fiveMPGamePurchase,
      tenMPGamePurchase,
      questPurchase,
      randomPurchase,
    ]);
    const expectedProfile6 = getPurchaseProfile({
      isQuestsAvailable: true,
      boughtMultiplayerGamesCount: 22,
    });
    expect(profile6).toEqual(expectedProfile6);
  });
});
