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
      const {
        updatedUser: inviterUser,
        isNewFriendAdded: isNewFriendAddedForInviter,
      } = await this.addFriendsToUser(userAddToFriend, [userId]);

      const device = await this.userProvider.getUserDevice(inviterUser.userId);

      if (device && isNewFriendAddedForInviter) {
        await this.firebaseMessaging
          .sendMulticastNotification({
            title: Strings.newFriend() + friendThatTapOnLink.updatedUser.userName,
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
    const { friends, isNewFriendAdded } = this.updateFriendsList(user, usersToAdd);

    const userWithNewFriends = produce(user, (draft) => {
      draft.friends = friends;
    });

    const updatedUser = await this.userProvider.updateUserProfile(userWithNewFriends);
    return { updatedUser, isNewFriendAdded };
  }

  private updateFriendsList(user: User, usersToAdd: UserEntity.Id[]) {
    const friends = user.friends || [];
    let isNewFriendAdded = false;

    usersToAdd
      .filter((userId) => userId !== user.userId)
      .forEach((userId) => {
        if (!friends.includes(userId)) {
          friends.push(userId);
          isNewFriendAdded = true;
        }
      });

    return { friends, isNewFriendAdded };
  }
}
