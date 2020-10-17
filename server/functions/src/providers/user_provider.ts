import { produce } from 'immer';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { UserEntity, UserDevice, User } from '../models/domain/user';
import { PurchaseDetails, PurchaseDetailsEntity } from '../models/purchases/purchase_details';
import { PurchaseProfileEntity } from '../models/purchases/purchase_profile';

export class UserProvider {
  constructor(private firestore: Firestore, private selector: FirestoreSelector) {}

  async getUserProfile(userId: UserEntity.Id): Promise<User> {
    const selector = this.selector.user(userId);
    const profile = (await this.firestore.getItemData(selector)) as User;

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

    if (JSON.stringify(profile) !== JSON.stringify(updatedProfile)) {
      await this.updateUserProfile(updatedProfile);
    }

    return updatedProfile;
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

  async updateUserProfile(user: User): Promise<User> {
    const selector = this.selector.user(user.userId);
    const profile = await this.firestore.updateItem(selector, user);
    return profile as User;
  }

  async getUserDevice(userId: UserEntity.Id): Promise<UserDevice> {
    const deviceSelector = this.selector.device(userId);
    const device = await this.firestore.getItemData(deviceSelector);
    return device as UserDevice;
  }

  async updateCurrentQuestIndex(userId: UserEntity.Id, index: number): Promise<void> {
    const selector = this.selector.user(userId);
    const user = (await this.firestore.getItemData(selector)) as User;

    const updatedUser = produce(user, (draft) => {
      const currentIndex = user.currentQuestIndex ?? 0;
      draft.currentQuestIndex = Math.max(currentIndex, index);
    });

    await this.firestore.updateItem(selector, updatedUser);
  }
}
