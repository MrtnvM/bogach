import { Firestore } from '../../core/firebase/firestore';
import { User } from '../../models/domain/user';
import { FirestoreSelector } from '../../providers/firestore_selector';
import { IUserDAO } from '../user_dao';

export class FirestoreUserDAO implements IUserDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async getUser(userId: string): Promise<User> {
    const userSelector = this.selector.user(userId);
    const user = (await this.firestore.getItemData(userSelector)) as User;
    return user;
  }
}
