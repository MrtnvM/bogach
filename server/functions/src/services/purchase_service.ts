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
    const multiplayer1Bought = products.some((p) => p === Purchases.multiplayer1ProductId) ? 1 : 0;
    const multiplayer5Bought = products.some((p) => p === Purchases.multiplayer5ProductId) ? 6 : 0;
    const multiplayer10Bought = products.some((p) => p === Purchases.multiplayer10ProductId)
      ? 12
      : 0;

    const multiplayerGamesCount = profile.multiplayerGamesCount ?? 0;

    const updatedProfile = produce(profile, (draft) => {
      draft.boughtQuestsAccess = profile.boughtQuestsAccess || isQuestsAccessBought;

      draft.multiplayerGamesCount =
        multiplayerGamesCount + multiplayer1Bought + multiplayer5Bought + multiplayer10Bought;
    });

    await this.userProvider.updateUserProfile(updatedProfile);
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
        const multiplayerGamesCount = (profile.multiplayerGamesCount ?? 0) - 1;

        if (multiplayerGamesCount < 0) {
          throw new Error("multiplayerGamesCount can't be less then zero");
        }

        draft.multiplayerGamesCount = multiplayerGamesCount;
      });

      return this.userProvider.updateUserProfile(updatedProfile);
    });

    await Promise.all(updatedParticipants);
  }
}
