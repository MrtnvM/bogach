import { produce } from 'immer';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { UserEntity, UserDevice, User } from '../models/domain/user';

export class UserProvider {
  constructor(private firestore: Firestore, private selector: FirestoreSelector) {}

  async getUserProfile(userId: UserEntity.Id): Promise<User> {
    const selector = this.selector.user(userId);
    const profile = await this.firestore.getItemData(selector);
    return profile as User;
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
