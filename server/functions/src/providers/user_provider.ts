import uuid = require('uuid');
import { produce } from 'immer';
import { UserEntity, UserDevice, User } from '../models/domain/user/user';
import { PurchaseDetails } from '../models/purchases/purchase_details';
import { PurchaseProfileEntity } from '../models/purchases/purchase_profile';
import { PlayedGames } from '../models/domain/user/played_games';
import { PlayedGameInfo } from '../models/domain/user/player_game_info';
import { nowInUtc } from '../utils/datetime';
import { IUserDAO } from '../dao/user_dao';
import { LastGamesEntity } from '../models/domain/user/last_games';
import { GameEntity } from '../models/domain/game/game';

export class UserProvider {
  constructor(private userDao: IUserDAO) {}

  async getUserProfile(userId: UserEntity.Id): Promise<User> {
    const profile = await this.userDao.getUser(userId);
    if (!profile) {
      throw Error('No user with this id: ' + userId);
    }

    const updatedProfile = this.migrateProfileToVersion3(profile);

    if (JSON.stringify(profile) !== JSON.stringify(updatedProfile)) {
      await this.updateUserProfile(updatedProfile);
    }

    return updatedProfile;
  }

  getUserPurchases(userId: UserEntity.Id): Promise<PurchaseDetails[]> {
    return this.userDao.getUserPurchases(userId);
  }

  addUserPurchases(userId: UserEntity.Id, purchases: PurchaseDetails[]): Promise<void> {
    return this.userDao.addUserPurchases(userId, purchases);
  }

  updateUserProfile(user: User): Promise<User> {
    return this.userDao.updateUserProfile(user);
  }

  getUserDevice(userId: UserEntity.Id): Promise<UserDevice> {
    return this.userDao.getUserDevice(userId);
  }

  async updateCurrentQuestIndex(userId: UserEntity.Id, index: number): Promise<void> {
    const user = await this.userDao.getUser(userId);

    const updatedUser = produce(user, (draft) => {
      const currentIndex = user.currentQuestIndex ?? 0;
      draft.currentQuestIndex = Math.max(currentIndex, index);
    });

    await this.userDao.updateUserProfile(updatedUser);
  }

  async removeGameFromLastGames(userId: UserEntity.Id, gameId: GameEntity.Id) {
    const user = await this.userDao.getUser(userId);
    const lastGames = user.lastGames || LastGamesEntity.initial();

    const updatedUser = produce(user, (draft) => {
      const singleplayerGames = lastGames.singleplayerGames.filter((g) => g.gameId !== gameId);
      const questGames = lastGames.questGames.filter((g) => g.gameId !== gameId);
      const multiplayerGames = lastGames.multiplayerGames.filter((g) => g.gameId !== gameId);

      draft.lastGames = {
        singleplayerGames,
        questGames,
        multiplayerGames,
      };
    });

    if (JSON.stringify(user) !== JSON.stringify(updatedUser)) {
      await this.userDao.updateUserProfile(updatedUser);
    }
  }

  private migrateProfileToVersion3(profile: User): User {
    let updatedProfile = profile;

    if (!profile.purchaseProfile) {
      updatedProfile = produce(updatedProfile, (draft) => {
        draft.purchaseProfile = PurchaseProfileEntity.initialPurchaseProfile;
        draft.purchaseProfile.isQuestsAvailable = updatedProfile.boughtQuestsAccess || false;
      });
    }

    if (!profile.multiplayerGamePlayed) {
      updatedProfile = produce(updatedProfile, (draft) => {
        draft.multiplayerGamePlayed = 0;
      });
    }

    if (!profile.profileVersion) {
      updatedProfile = produce(updatedProfile, (draft) => {
        draft.profileVersion = 3;
      });
    }

    if (!profile.playedGames) {
      updatedProfile = produce(updatedProfile, (draft) => {
        const multiplayerGamePlayed = updatedProfile.multiplayerGamePlayed || 0;
        const multiplayerGames: PlayedGameInfo[] = [];

        for (let gameIndex = 0; gameIndex < multiplayerGamePlayed; gameIndex++) {
          const playedMultiplayerGame: PlayedGameInfo = {
            gameId: uuid.v4(),
            createdAt: nowInUtc(),
          };

          multiplayerGames.push(playedMultiplayerGame);
        }

        const playedGameInfo: PlayedGames = {
          multiplayerGames: multiplayerGames,
        };

        draft.playedGames = playedGameInfo;
      });
    }

    if (!profile.lastGames) {
      updatedProfile = produce(updatedProfile, (draft) => {
        draft.lastGames = LastGamesEntity.initial();
      });
    }

    return updatedProfile;
  }
}
