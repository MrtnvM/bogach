import { produce } from 'immer';

import { UserProvider } from '../../providers/user_provider';
import { UserEntity } from '../../models/domain/user';
import { Purchases } from '../../core/purchases/purchases';
import { PurchaseDetails } from '../../models/purchases/purchase_details';
import { PurchaseProfile, PurchaseProfileEntity } from '../../models/purchases/purchase_profile';

export class PurchaseService {
  constructor(private userProvider: UserProvider) {}

  async updatePurchases(
    userId: UserEntity.Id,
    purchases: PurchaseDetails[]
  ): Promise<PurchaseProfile | undefined> {
    if (!userId || !purchases || !Array.isArray(purchases)) {
      throw new Error('Purchase list has incorrect format');
    }

    if (purchases.length === 0) {
      return undefined;
    }

    const userProfile = await this.userProvider.getUserProfile(userId);
    const pastPurchases = await this.userProvider.getUserPurchases(userId);

    const purchasesMap: { [key: string]: PurchaseDetails } = {};
    pastPurchases.forEach((p) => (purchasesMap[p.purchaseId] = p));
    purchases.forEach((p) => (purchasesMap[p.purchaseId] = p));

    const allPurchases = Object.values(purchasesMap);
    const purchaseProfile = this.recalculatePurchaseProfile(allPurchases);

    const updatedProfile = produce(userProfile, (draft) => {
      draft.boughtQuestsAccess = purchaseProfile.isQuestsAvailable;
      draft.purchaseProfile = purchaseProfile;
    });

    if (JSON.stringify(userProfile) !== JSON.stringify(updatedProfile)) {
      await this.userProvider.updateUserProfile(updatedProfile);
    }

    const pastPurchasesMap: { [key: string]: PurchaseDetails } = {};
    pastPurchases.forEach((p) => (pastPurchasesMap[p.purchaseId] = p));

    const newPurchases = purchases.filter((p) => pastPurchasesMap[p.purchaseId] === undefined);
    await this.userProvider.addUserPurchases(userId, newPurchases);

    return purchaseProfile;
  }

  recalculatePurchaseProfile(allPurchases: PurchaseDetails[]): PurchaseProfile {
    const hasPurchase = (productId: string) => {
      return allPurchases.some((p) => p.productId === productId);
    };

    const isQuestsAvailable = hasPurchase(Purchases.questsAccessProductId);

    const multiplayerGamePurchases: { [productId: string]: number } = {
      [Purchases.multiplayer1ProductId]: 1,
      [Purchases.multiplayer5ProductId]: 6,
      [Purchases.multiplayer10ProductId]: 12,
    };

    const boughtMultiplayerGamesCount = allPurchases
      .map((p) => multiplayerGamePurchases[p.productId] || 0)
      .reduce((total, curr) => total + curr, PurchaseProfileEntity.initialMultiplayerGamesCount);

    return {
      isQuestsAvailable,
      boughtMultiplayerGamesCount: boughtMultiplayerGamesCount,
    };
  }

  async reduceMultiplayerGames(participantsIds: UserEntity.Id[]) {
    if (!Array.isArray(participantsIds) || participantsIds?.length === 0) {
      throw new Error("ParticipantIds can't be empty");
    }

    const participants = await Promise.all(
      participantsIds.map((userId) => this.userProvider.getUserProfile(userId))
    );

    const updatedParticipants = participants.map((profile) => {
      const updatedProfile = produce(profile, (draft) => {
        const multiplayerGamePlayed = (draft.multiplayerGamePlayed || 0) + 1;
        draft.multiplayerGamePlayed = multiplayerGamePlayed;

        const boughtMultiplayerGamesCount =
          draft.purchaseProfile?.boughtMultiplayerGamesCount !== undefined
            ? draft.purchaseProfile?.boughtMultiplayerGamesCount
            : PurchaseProfileEntity.initialMultiplayerGamesCount;

        const availableGames = boughtMultiplayerGamesCount - multiplayerGamePlayed;

        if (availableGames <= 0) {
          throw new Error("multiplayerGamesCount can't be less then zero");
        }
      });

      return this.userProvider.updateUserProfile(updatedProfile);
    });

    await Promise.all(updatedParticipants);
  }
}
