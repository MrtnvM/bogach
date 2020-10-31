import * as admin from 'firebase-admin';
import { User } from './models/domain/user/user';

export const initializeTestDataIfEmulator = () => {
  if (process.env.FUNCTIONS_EMULATOR !== 'true') {
    return;
  }

  initializeUsers();
};

const initializeUsers = () => {
  const firestore = admin.firestore();
  const usersCollection = firestore.collection('users');

  const user1: User = {
    userId: 'WBVDHp4RwkNZ3ua7MqqsbhcVLQ03',
    userName: 'John Gold',
    avatarUrl:
      'https://lh5.googleusercontent.com/-4kvAklpYHJs/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucm6SFmc2IWbw78WsnzyQlDZPuspog/s96-c/photo.jpg',
    purchaseProfile: {
      isQuestsAvailable: false,
      boughtMultiplayerGamesCount: 3,
    },
    profileVersion: 2,
    multiplayerGamePlayed: 0,
    playedGames: {
      multiplayerGames: [],
    },
    updatedAt: '2020-10-30T22:37:10.000Z',
  };

  usersCollection.doc(user1.userId).set(user1);

  const user2: User = {
    userId: 'vO4mXjQo7Ba8m5dIs5LOgAthgsJ3',
    userName: 'James Bond',
    avatarUrl: 'https://graph.facebook.com/110000310680186/picture',
    purchaseProfile: {
      isQuestsAvailable: false,
      boughtMultiplayerGamesCount: 3,
    },
    profileVersion: 2,
    multiplayerGamePlayed: 0,
    playedGames: {
      multiplayerGames: [],
    },
    updatedAt: '2020-10-30T22:37:10.000Z',
  };

  usersCollection.doc(user2.userId).set(user2);
};
