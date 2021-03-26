import { Firestore } from '../../core/firebase/firestore';
import { OnlineProfile, OnlineProfileEntity } from '../../models/domain/multiplayer/online_profile';
import { User, UserDevice, UserEntity } from '../../models/domain/user/user';
import { PurchaseDetails, PurchaseDetailsEntity } from '../../models/purchases/purchase_details';
import { FirestoreSelector } from '../../providers/firestore_selector';
import { nowInUtc } from '../../utils/datetime';
import { IUserDAO } from '../user_dao';

export class FirestoreUserDAO implements IUserDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async getUser(userId: UserEntity.Id): Promise<User> {
    const userSelector = this.selector.user(userId);
    const user = (await this.firestore.getItemData(userSelector)) as User;
    return user;
  }

  async updateUserProfile(user: User): Promise<User> {
    const selector = this.selector.user(user.userId);
    const profile = await this.firestore.updateItem(selector, user);
    return profile as User;
  }

  async getUserPurchases(userId: UserEntity.Id): Promise<PurchaseDetails[]> {
    const selector = this.selector.userPurchases(userId);
    const purchases = (await this.firestore.getItems(selector)) || [];
    purchases.forEach(PurchaseDetailsEntity.validate);
    return purchases as PurchaseDetails[];
  }

  async addUserPurchases(userId: UserEntity.Id, purchases: PurchaseDetails[]): Promise<void> {
    const selector = this.selector.userPurchases(userId);
    await Promise.all(purchases.map((p) => this.firestore.addItem(selector, p)));
  }

  async getUserDevice(userId: UserEntity.Id): Promise<UserDevice> {
    const deviceSelector = this.selector.device(userId);
    const device = await this.firestore.getItemData(deviceSelector);
    return device as UserDevice;
  }

  async setOnlineStatus(user: OnlineProfile): Promise<void> {
    await this.selector.recentSession(user.userId).set(user);
  }

  async getOnlineProfiles(userId: UserEntity.Id): Promise<OnlineProfile[]> {
    const milliseconds = 30 * 1_000;
    const minTimeOnline = nowInUtc() - milliseconds;

    const query = this.selector.recentSessions().orderBy('onlineAt', 'desc').limit(6);

    const onlineProfiles = (await this.firestore.getQueryItems(query)) || [];
    onlineProfiles.forEach(OnlineProfileEntity.validate);
    return (onlineProfiles as OnlineProfile[]).filter(
      (profile) => profile.userId != userId && profile.onlineAt >= minTimeOnline
    );
  }
}
