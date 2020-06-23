import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { UserEntity, UserDevice } from '../models/domain/user';

export class UserProvider {
  constructor(private firestore: Firestore, private selector: FirestoreSelector) {}

  async getUserDevice(userId: UserEntity.Id): Promise<UserDevice> {
    const deviceSelector = this.selector.device(userId);
    const device = await this.firestore.getItemData(deviceSelector);
    return device as UserDevice;
  }
}
