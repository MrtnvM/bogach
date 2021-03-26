import { User } from '../../models/domain/user/user';

export namespace UserFixture {
  export const createUser = (user: Partial<User> | undefined = undefined): User => {
    const createdUser: User = {
      userId: user?.userId || 'user1',
      userName: user?.userName || 'John Snow',
      avatarUrl: 'https://image.flaticon.com/icons/png/128/1907/1907938.png',

      profileVersion: 3,

      purchaseProfile: user?.purchaseProfile || {
        isQuestsAvailable: false,
        boughtMultiplayerGamesCount: 3,
      },
    };

    return createdUser;
  };
}
