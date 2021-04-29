import { produce } from 'immer';

import { UserProvider } from '../../providers/user_provider';
import { UserEntity } from '../../models/domain/user/user';
import { Purchases } from '../../core/purchases/purchases';
import { PurchaseDetails } from '../../models/purchases/purchase_details';
import { PurchaseProfile, PurchaseProfileEntity } from '../../models/purchases/purchase_profile';
import { ErrorRecorder } from '../../config';

export class PurchaseService {
  constructor(private userProvider: UserProvider) {}

  private errorRecorder = new ErrorRecorder('Purchase Service');

  async updatePurchases(
    userId: UserEntity.Id,
    purchases: PurchaseDetails[]
  ): Promise<PurchaseProfile | undefined> {
    return this.errorRecorder.executeWithErrorRecording({ userId, purchases }, async () => {
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
    });
  }

  recalculatePurchaseProfile(allPurchases: PurchaseDetails[]): PurchaseProfile {
    const hasPurchase = (productId: string) => {
      return allPurchases.some((p) => p.productId === productId);
    };

    const isQuestsAvailable = hasPurchase(Purchases.questsAccessProductId);

    const multiplayerGamePurchases: { [productId: string]: number } = {
      [Purchases.depricatedMultiplayer1ProductId]: 1,
      [Purchases.depricatedMultiplayer5ProductId]: 6,
      [Purchases.depricatedMultiplayer10ProductId]: 12,

      [Purchases.multiplayerGames1]: 1,
      [Purchases.multiplayerGames10]: 10,
      [Purchases.multiplayerGames25]: 25,
    };

    const boughtMultiplayerGamesCount = allPurchases
      .map((p) => multiplayerGamePurchases[p.productId] || 0)
      .reduce((total, curr) => total + curr, PurchaseProfileEntity.initialMultiplayerGamesCount);

    return {
      isQuestsAvailable,
      boughtMultiplayerGamesCount: boughtMultiplayerGamesCount,
    };
  }
}
