import * as admin from 'firebase-admin';
import * as express from 'express';

import * as GameAPI from './api_new/game';
import * as RecommendationsAPI from './api_new/recommendations';
import * as MultiplayerAPI from './api_new/multiplayer';
import * as PurchaseAPI from './api_new/purchase';
import * as RoomAPI from './api_new/room';
import * as UserAPI from './api_new/user';

import { FirestoreSelector } from './providers/firestore_selector';
import { Firestore } from './core/firebase/firestore';
import { getCredentials, getDatabaseURL, getStorageBucket } from './config';
import { RealtimeDatabaseRefs } from './dao/realtime_database/realtime_database_refs';
import { RealtimeDatabase } from './core/firebase/realtime_database';
import { RealtimeDatabaseGameDAO } from './dao/realtime_database/realtime_database_game_dao';
import { FirestoreRoomDAO } from './dao/firestore/firestore_room_dao';
import { FirestoreUserDAO } from './dao/firestore/firestore_user_dao';
import { DAOs } from './dao/daos';
import { FirestoreLevelStatisticDAO } from './dao/firestore/firestore_level_statistic_dao';
import { FirestoreBookRecommendationsDAO } from './dao/firestore/firestore_book_recommendations_dao';

admin.initializeApp({
  databaseURL: getDatabaseURL(),
  storageBucket: getStorageBucket(),
  credential: admin.credential.cert(getCredentials()),
});

console.log('Firebase initialized!');

const adminFirestore = admin.firestore();
const adminStorage = admin.storage();

const selector = new FirestoreSelector(adminFirestore);
const firestore = new Firestore();

const realtimeDatabase = admin.database();
const refs = new RealtimeDatabaseRefs(realtimeDatabase);
const db = new RealtimeDatabase();

const gameDao = new RealtimeDatabaseGameDAO(refs, db);
const roomDao = new FirestoreRoomDAO(selector, firestore);
const userDao = new FirestoreUserDAO(selector, firestore);
const levelStatisticDao = new FirestoreLevelStatisticDAO(selector, firestore);
const bookRecommendationsDao = new FirestoreBookRecommendationsDAO(selector, firestore);

const daos: DAOs = {
  game: gameDao,
  user: userDao,
  room: roomDao,
  levelStatistic: levelStatisticDao,
  bookRecommendations: bookRecommendationsDao,
};

const app = express();
app.use(express.json());
const PORT = 3000;

GameAPI.initialize(daos, app);
RoomAPI.initialize(daos, app);
MultiplayerAPI.initialize(daos, app);
UserAPI.initialize(daos, app);
PurchaseAPI.initialize(daos, app);
RecommendationsAPI.initialize(daos, adminStorage, app);

app.listen(PORT, () => {
  console.log('App started on port: ', PORT);
});
