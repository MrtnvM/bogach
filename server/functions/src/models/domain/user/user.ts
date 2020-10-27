import { PurchaseProfile } from '../../purchases/purchase_profile';
import { PlayedGames } from './played_games';

export interface User {
  readonly userId: UserEntity.Id;
  readonly userName: string;

  readonly currentQuestIndex?: number;
  readonly boughtQuestsAccess?: boolean;

  readonly multiplayerGamePlayed?: number;
  readonly purchaseProfile?: PurchaseProfile;

  readonly profileVersion?: number;

  readonly createdAt?: Date;
  readonly updatedAt?: Date;

  readonly playedGames?: PlayedGames;
}

export interface UserDevice {
  platform: 'ios' | 'android';
  token: string;
}

export namespace UserEntity {
  export type Id = string;
}
