/// <reference types="@types/jest"/>

import * as admin from 'firebase-admin';
import { Game } from './models/domain/game/game';

admin.initializeApp({
  databaseURL: 'https://cash-flow-staging.firebaseio.com',
  storageBucket: 'cash-flow-staging.appspot.com',
});

describe('Firebase sandbox', () => {
  test.skip('Get Last Game', async () => {
    jest.setTimeout(15_000);

    const lastGame = await getLastGame();
    const gameLogger = GameLogger(lastGame);

    gameLogger.logGameId();
    gameLogger.logUpdatedAt();
    gameLogger.logGameState();
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
