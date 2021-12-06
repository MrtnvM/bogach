/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { Firestore } from './core/firebase/firestore';
import { RealtimeDatabase } from './core/firebase/realtime_database';
import { FirestoreUserDAO } from './dao/firestore/firestore_user_dao';
import { RealtimeDatabaseGameDAO } from './dao/realtime_database/realtime_database_game_dao';
import { RealtimeDatabaseRefs } from './dao/realtime_database/realtime_database_refs';
import { Game } from './models/domain/game/game';
import { PurchaseDetails } from './models/purchases/purchase_details';
import { FirestoreSelector } from './providers/firestore_selector';
import { UserProvider } from './providers/user_provider';
import { PurchaseService } from './services/purchase/purchase_service';
import {
  applyGameTransformers,
  GameEventsTransformer,
  HistoryGameTransformer,
} from './transformers/game_transformers';
import { writeJson } from './utils/json';

const stagingConfig = {
  databaseURL: 'https://cash-flow-staging.firebaseio.com',
  storageBucket: 'cash-flow-staging.appspot.com',
  credential: admin.credential.cert(
    require('../environments/staging/firebase_service_account.json')
  ),
};

const productionConfig = {
  databaseURL: 'https://bogach-production.firebaseio.com',
  storageBucket: 'bogach-production.appspot.com',
  credential: admin.credential.cert(
    require('../environments/production/firebase_service_account.json')
  ),
};

/// Linter fix
const linterFix = true;
if (!linterFix) {
  console.log([stagingConfig, productionConfig]);
}

admin.initializeApp(stagingConfig);

describe('Firebase sandbox', () => {
  test.skip('Query purchasers from Firestore', async () => {
    jest.setTimeout(15_000);

    const firestore = admin.firestore();
    const usersRef = firestore.collection('users');

    const query = usersRef.where('purchaseProfile.isQuestsAvailable', '==', true);
    const queryResult = await query.get();

    const questPurchasers = queryResult.docs
      .map((doc) => doc.data())
      .map((u) => [u.userName, u.userId]);

    const path = 'data/purchasers.json';

    writeJson(path, questPurchasers);
  });

  test.skip('Give bonus to Quests Purchaser', async () => {
    jest.setTimeout(90_000);

    const userId = '';

    const firestore = admin.firestore();
    const devicesRef = firestore.collection('devices');
    const deviceDoc = await devicesRef.doc(userId).get();
    const device = deviceDoc.data() || {};

    const selector = new FirestoreSelector(firestore);
    const firestoreInstance = new Firestore();
    const userDao = new FirestoreUserDAO(selector, firestoreInstance);
    const userProvider = new UserProvider(userDao);
    const purchaseService = new PurchaseService(userProvider);

    const purchaseDetails: PurchaseDetails = {
      productId: 'bogach.multiplayer.games.10',
      purchaseId: '10000007925390781',
    };

    await purchaseService.updatePurchases(userId, [purchaseDetails]);

    const messaging = admin.messaging();
    await messaging.send({
      token: device.token,
      notification: {
        title: 'Стал обладателем квестов?',
        body: 'Лови +10 мультиплеерных игр в качестве бонуса!',
      },
    });

    console.log('Push notification sent');
  });

  test.skip('Get user profile', async () => {
    const userId = 'w05ns50DYyRzNZ7YYjG2NzcPyfM2';

    const firestore = admin.firestore();
    const selector = new FirestoreSelector(firestore);
    const firestoreInstance = new Firestore();
    const userDao = new FirestoreUserDAO(selector, firestoreInstance);
    const userProvider = new UserProvider(userDao);

    const profile = await userProvider.getUserProfile(userId);
    console.log(JSON.stringify(profile, null, 2));
  });

  test.skip('Get game', async () => {
    const gameId = '7d7a2d0d-a51c-497f-a7f6-80fb5d546e2b';
    const realtimeDatabase = admin.database();
    const gameRef = realtimeDatabase.ref('games').child(gameId);
    const game = await gameRef.once('value');

    const path = `data/games/Game - ${gameId}.json`;
    writeJson(path, game);
  });

  test.skip('Test game transformer with data from DB', async () => {
    jest.setTimeout(15_000);

    const realtimeDatabase = admin.database();
    const refs = new RealtimeDatabaseRefs(realtimeDatabase);
    const db = new RealtimeDatabase();

    const gameDao = new RealtimeDatabaseGameDAO(refs, db);
    const game = await gameDao.getGame('cadd758c-c6b9-431c-b3a0-9c12c028aa72');

    const transformers = [new HistoryGameTransformer(), new GameEventsTransformer()];
    const updatedGame = applyGameTransformers(game, transformers);

    console.log(updatedGame);
  });

  test.skip('Get Last Game', async () => {
    jest.setTimeout(15_000);

    const lastGame = await getLastGame();
    const gameLogger = GameLogger(lastGame);

    gameLogger.logGameId();
    gameLogger.logUpdatedAt();
    gameLogger.logGameState();
  });

  test.skip('Get Game By Condition', async () => {
    jest.setTimeout(15_000);

    await admin
      .database()
      .ref('games')
      /// < Your condition here >
      /// order then use startAt, endAt, equalTo
      ///
      /// Use this article:
      /// https://howtofirebase.com/collection-queries-with-firebase-b95a0193745d
      .once('value', (snapshot) => {
        const itemsCount = snapshot.numChildren();
        console.log(itemsCount);

        if (itemsCount === 0) {
          return;
        }

        const participantId = 'l2xHfb3MGAOAr3yFCg490N1Yl6I3';
        const games = Object.values(snapshot.toJSON() || {}) as Game[];

        const gamesWithParticipant = games.filter((game) => game.participants[participantId]);

        console.log(gamesWithParticipant);
      });

    await new Promise((resolve, reject) => {
      setTimeout(resolve, 15_000);
    });
  });
});

const getLastGame = async () => {
  const gamesCollection = admin.firestore().collection('games');
  const lastGameQueryResult = await gamesCollection.orderBy('updatedAt', 'desc').limit(1).get();
  const lastGame = lastGameQueryResult.docs[0]?.data() as Game;

  return lastGame;
};

const GameLogger = (game: Game) => {
  const dateFromTimestamp = (timestamp: any) => {
    return (timestamp as admin.firestore.Timestamp).toDate();
  };

  const log = (name: string, value: any) => {
    const printedValue = typeof value === 'object' ? JSON.stringify(value, null, 2) : value;
    console.log(name + ': \n' + printedValue + '\n');
  };

  return {
    logGameId: () => log('GameId', game.id),
    logGameState: () => log('Game State', game.state),
    logCurrentEvents: () => log('Current Events', game.currentEvents),
    logHistory: () => log('History', game.history),
    logCreatedAt: () => log('Created At', dateFromTimestamp(game.updatedAt).toISOString()),
    logUpdatedAt: () => log('Updated At', dateFromTimestamp(game.updatedAt).toISOString()),
  };
};
