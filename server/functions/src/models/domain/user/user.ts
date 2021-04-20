import { PurchaseProfile } from '../../purchases/purchase_profile';
import { PlayedGames } from './played_games';
import { LastGames } from './last_games';

export interface User {
  readonly userId: UserEntity.Id;
  readonly userName: string;
  readonly avatarUrl: string;

  readonly currentQuestIndex?: number;
  readonly boughtQuestsAccess?: boolean;

  readonly multiplayerGamePlayed?: number;
  readonly purchaseProfile?: PurchaseProfile;

  readonly profileVersion?: number;

  readonly createdAt?: string;
  readonly updatedAt?: string;

  readonly playedGames?: PlayedGames;
  readonly lastGames?: LastGames;
  readonly completedGames?: LastGames;

  readonly friends?: UserEntity.Id[];
}

export interface UserDevice {
  platform: 'ios' | 'android';
  token: string;
}

export namespace UserEntity {
  export type Id = string;
}
