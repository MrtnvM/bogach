import { produce, Draft } from 'immer';

import { UserProvider } from '../../providers/user_provider';
import { UserEntity, User } from '../../models/domain/user/user';
import { Purchases } from '../../core/purchases/purchases';
import { PurchaseDetails } from '../../models/purchases/purchase_details';
import { PurchaseProfile, PurchaseProfileEntity } from '../../models/purchases/purchase_profile';
import { GameEntity } from '../../models/domain/game/game';
import { PlayedGameInfo } from '../../models/domain/user/player_game_info';
import { nowInUtc } from '../../utils/datetime';
import { getCurrentEnvironment, rollbar } from '../../config';

export class PurchaseService {
  constructor(private userProvider: UserProvider) {}

  async updatePurchases(
    userId: UserEntity.Id,
    purchases: PurchaseDetails[]
  ): Promise<PurchaseProfile | undefined> {
    return this.executeWithErrorReporting({ userId, purchases }, async () => {
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

  async reduceMultiplayerGames(
    participantsIds: UserEntity.Id[],
    gameId: GameEntity.Id,
    gameCreationDate?: number
  ) {
    const context = { participantsIds, gameId, gameCreationDate };

    return this.executeWithErrorReporting(context, async () => {
      if (!Array.isArray(participantsIds) || participantsIds?.length === 0) {
        throw new Error("ParticipantIds can't be empty");
      }

      const participants = await Promise.all(
        participantsIds.map((userId) => this.userProvider.getUserProfile(userId))
      );

      const updatedParticipants = this.updateProfileStates(participants, gameId, gameCreationDate);

      await Promise.all(updatedParticipants);
    });
  }

  private updateProfileStates(
    participants: User[],
    gameId: string,
    gameCreationDate?: number
  ): Promise<User>[] {
    const updatedParticipants = participants.map((profile) => {
      const updatedProfile = produce(profile, (draft) => {
        if (!draft.playedGames) {
          draft.playedGames = {
            multiplayerGames: [],
          };
        }

        draft.playedGames.multiplayerGames = this.addMultiplayerGame(
          draft,
          gameId,
          gameCreationDate
        );

        const multiplayerGamePlayed = draft.playedGames?.multiplayerGames?.length || 0;

        const boughtMultiplayerGamesCount =
          draft.purchaseProfile?.boughtMultiplayerGamesCount !== undefined
            ? draft.purchaseProfile?.boughtMultiplayerGamesCount
            : PurchaseProfileEntity.initialMultiplayerGamesCount;

        const availableGames = boughtMultiplayerGamesCount - multiplayerGamePlayed;

        if (availableGames < 0) {
          throw new Error("multiplayerGamesCount can't be less then zero");
        }
      });
      return this.userProvider.updateUserProfile(updatedProfile);
    });

    return updatedParticipants;
  }

  private addMultiplayerGame(draft: Draft<User>, gameId: string, gameCreationDate?: number) {
    const multiplayerGameInfo: PlayedGameInfo = {
      gameId: gameId,
      createdAt: gameCreationDate || nowInUtc(),
    };

    draft.playedGames!.multiplayerGames.push(multiplayerGameInfo);

    return draft.playedGames!.multiplayerGames;
  }

  private async executeWithErrorReporting<T>(context: any, callback: () => Promise<T>): Promise<T> {
    const component = 'Purchase Service';
    const environment = getCurrentEnvironment();

    try {
      return await callback();
    } catch (err) {
      const errorMessage =
        'PURCHASE SERVICE\n' +
        `ENVIRONMENT: ${environment}\n` +
        `ERROR MESSAGE: ${err && err['message']}\n` +
        `CONTEXT: ${JSON.stringify(context, null, 2)}`;

      const error = new Error(errorMessage);
      rollbar.error(error, `COMPONENT: ${component}, ` + `ENVIRONMENT: ${environment}`);
      throw error;
    }
  }
}
