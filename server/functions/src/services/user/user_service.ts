import { UserProvider } from '../../providers/user_provider';
import { User, UserEntity } from '../../models/domain/user/user';
import produce from 'immer';
import { FirebaseMessaging } from '../../core/firebase/firebase_messaging';
import { Strings } from '../../resources/strings';
import { rollbar } from '../../config';

export class UserService {
  constructor(private userProvider: UserProvider, private firebaseMessaging: FirebaseMessaging) {}

  /// Friend that taps on inviter link executes this function
  async addFriends(props: { userId: string; usersAddToFriends: string[] }) {
    const { userId, usersAddToFriends } = props;

    /// Adding friend (inviter) to user that tap on link
    const friendThatTapOnLink = await this.addFriendsToUser(userId, usersAddToFriends);

    /// Adding friend that tap on link to the inviter user
    usersAddToFriends.forEach(async (userAddToFriend) => {
      const inviterUser = await this.addFriendsToUser(userAddToFriend, [userId]);
      const device = await this.userProvider.getUserDevice(inviterUser.userId);

      if (device) {
        await this.firebaseMessaging
          .sendMulticastNotification({
            title: Strings.newFriend() + friendThatTapOnLink.userName,
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

  async removeFromFriends(props: { userId: UserEntity.Id; removedFriendId: UserEntity.Id }) {
    const { userId, removedFriendId } = props;

    const user = await this.userProvider.getUserProfile(userId);

    const updatedUser = produce(user, (draft) => {
      const friends = draft.friends ?? [];
      const updatedFriends = friends.filter((id) => id !== removedFriendId);
      draft.friends = updatedFriends;
    });

    await this.userProvider.updateUserProfile(updatedUser);
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
