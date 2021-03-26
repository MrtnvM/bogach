import { OnlineProfile } from '../models/domain/multiplayer/online_profile';
import { User, UserDevice, UserEntity } from '../models/domain/user/user';
import { PurchaseDetails } from '../models/purchases/purchase_details';

export interface IUserDAO {
  getUser(userId: UserEntity.Id): Promise<User>;
  updateUserProfile(user: User): Promise<User>;

  getUserPurchases(userId: UserEntity.Id): Promise<PurchaseDetails[]>;
  addUserPurchases(userId: UserEntity.Id, purchases: PurchaseDetails[]): Promise<void>;

  getUserDevice(userId: UserEntity.Id): Promise<UserDevice>;

  setOnlineStatus(user: OnlineProfile): Promise<void>;
  getOnlineProfiles(userId: UserEntity.Id): Promise<OnlineProfile[]>;
}
