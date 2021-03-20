import { UserProvider } from '../../providers/user_provider';
import { User, UserEntity } from '../../models/domain/user/user';
import produce from 'immer';
import { FirebaseMessaging } from '../../core/firebase/firebase_messaging';
import { Strings } from '../../resources/strings';
import { rollbar } from '../../config';

export class UserService {
  constructor(private userProvider: UserProvider, private firebaseMessaging: FirebaseMessaging) {}

  async addFriends(props: { userId: string; usersAddToFriends: string[] }) {
    const { userId, usersAddToFriends } = props;

    /// Adding friends to current user
    await this.addFriendsToUser(userId, usersAddToFriends);

    /// Adding current user as friend to invited users
    usersAddToFriends.forEach(async (userAddToFriend) => {
      const friend = await this.addFriendsToUser(userAddToFriend, [userId]);
      const device = await this.userProvider.getUserDevice(friend.userId);

      if (device) {
        await this.firebaseMessaging
          .sendMulticastNotification({
            title: Strings.newFriend() + friend.userName,
            body: Strings.friendRequestAccepted(),
            data: { type: 'new_friend' },
            pushTokens: [device.token],
          })
          .catch((e) => {
            rollbar.error(e, 'Failed to send new friend push notification');
          });
      }
    });
  }

  private async addFriendsToUser(userId: UserEntity.Id, usersToAdd: string[]) {
    const user = await this.userProvider.getUserProfile(userId);

    const userWithNewFriends = produce(user, (draft) => {
      draft.friends = this.updateFriendsList(user, usersToAdd);
    });

    const updatedUser = await this.userProvider.updateUserProfile(userWithNewFriends);
    return updatedUser;
  }

  private updateFriendsList(user: User, usersToAdd: string[]) {
    const currentFriends = user.friends || [];

    usersToAdd
      .filter((userId) => userId !== user.userId)
      .forEach((userId) => {
        if (!currentFriends.includes(userId)) {
          currentFriends.push(userId);
        }
      });

    return currentFriends;
  }
}
