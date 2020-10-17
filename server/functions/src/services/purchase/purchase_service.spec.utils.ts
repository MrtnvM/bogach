import { User } from '../../models/domain/user';
import { PurchaseDetails } from '../../models/purchases/purchase_details';
import { PurchaseProfile, PurchaseProfileEntity } from '../../models/purchases/purchase_profile';

const userId = 'user1';

const getInitialProfile = (profile?: Partial<User>): User => {
  return {
    userId: profile?.userId || userId,
    userName: profile?.userName || 'John Dow',

    currentQuestIndex: profile?.currentQuestIndex,
    boughtQuestsAccess: profile?.boughtQuestsAccess,

    multiplayerGamePlayed: profile?.multiplayerGamePlayed || 0,
    purchaseProfile: profile?.purchaseProfile,
  };
};

const getPurchase = (purchase: Partial<PurchaseDetails>): PurchaseDetails => {
  if (!purchase?.productId) {
    throw new Error('[purchaseId] can not be undefined');
  }

  return {
    productId: purchase.productId,
    purchaseId: purchase.purchaseId || `${purchase.productId} purchase`,
    verificationData: purchase.verificationData || 'verification_token_1',
    source: purchase.source || 'AppStore',
  };
};

const getPurchaseProfile = (profile: Partial<PurchaseProfile>): PurchaseProfile => {
  return {
    isQuestsAvailable: profile.isQuestsAvailable || false,
    boughtMultiplayerGamesCount:
      profile.boughtMultiplayerGamesCount || PurchaseProfileEntity.initialMultiplayerGamesCount,
  };
};

export const TestData = {
  userId,
  getInitialProfile,
  getPurchase,
  getPurchaseProfile,
};
