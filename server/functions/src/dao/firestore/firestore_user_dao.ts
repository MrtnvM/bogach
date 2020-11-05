import { Firestore } from '../../core/firebase/firestore';
import { User, UserDevice, UserEntity } from '../../models/domain/user/user';
import { PurchaseDetails, PurchaseDetailsEntity } from '../../models/purchases/purchase_details';
import { FirestoreSelector } from '../../providers/firestore_selector';
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
}
