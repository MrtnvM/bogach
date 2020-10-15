export interface User {
  readonly userId: UserEntity.Id;
  readonly userName: string;

  readonly currentQuestIndex?: number;
  readonly boughtQuestsAccess?: boolean;

  readonly multiplayerGamePlayed?: number;
  readonly purchaseProfile?: PurchaseProfile;

  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export interface PurchaseProfile {
  readonly isQuestsAvailable: boolean;
  readonly boughtMultiplayerGamesCount: number;
}

export namespace PurchaseProfileEntity {
  export const initialMultiplayerGamesCount = 3;

  export const initialPurchaseProfile: PurchaseProfile = {
    isQuestsAvailable: false,
    boughtMultiplayerGamesCount: initialMultiplayerGamesCount,
  };
}

export interface UserDevice {
  platform: 'ios' | 'android';
  token: string;
}

export namespace UserEntity {
  export type Id = string;
}
