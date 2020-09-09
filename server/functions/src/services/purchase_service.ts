import { produce } from 'immer';

import { UserProvider } from '../providers/user_provider';
import { UserEntity } from '../models/domain/user';
import { Purchases } from '../core/purchases/purchases';

export class PurchaseService {
  constructor(private userProvider: UserProvider) {}

  async updatePurchases(userId: UserEntity.Id, products: string[]) {
    if (!userId || !products || !Array.isArray(products) || products?.length === 0) {
      return;
    }

    const profile = await this.userProvider.getUserProfile(userId);
    const isQuestsAccessBought = products.some((p) => p === Purchases.questsAccessProductId);

    const updatedProfile = produce(profile, (draft) => {
      draft.boughtQuestsAccess = profile.boughtQuestsAccess || isQuestsAccessBought;
    });

    await this.userProvider.updateUserProfile(updatedProfile);
  }
}
