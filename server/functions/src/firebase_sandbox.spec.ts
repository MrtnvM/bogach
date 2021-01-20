/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { Game } from './models/domain/game/game';

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

admin.initializeApp(productionConfig);

describe('Firebase sandbox', () => {
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
