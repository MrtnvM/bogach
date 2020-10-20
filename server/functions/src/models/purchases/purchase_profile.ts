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
