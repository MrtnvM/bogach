import * as admin from 'firebase-admin';
import * as Debug from './debug';

import * as gameAPI from './api/game';
import * as multiplayerAPI from './api/multiplayer';
import * as roomAPI from './api/room';
import * as purchaseAPI from './api/purchase';
import * as userAPI from './api/user';
import * as recommendationsApi from './api/recommendations';

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

const GameAPI = gameAPI.create(daos);
const RoomAPI = roomAPI.create(daos);
const PurchaseAPI = purchaseAPI.create(daos);
const UserAPI = userAPI.create(daos);
const MultiplayerAPI = multiplayerAPI.create(daos);
const RecommendationsAPI = recommendationsApi.create(daos, adminStorage);

export const createGame = GameAPI.create;
export const getGame = GameAPI.getGame;
export const getGameTemplate = GameAPI.getGameTemplate;
export const getAllGameTemplates = GameAPI.getAllGameTemplates;
export const handleGameEvent = GameAPI.handleGameEvent;
export const startNewMonth = GameAPI.startNewMonth;
export const gameLevels = GameAPI.getGameLevels;
export const createGameByLevel = GameAPI.createGameByLevel;

export const createRoom = RoomAPI.createRoom;
export const setRoomParticipantReady = RoomAPI.setRoomParticipantReady;
export const createRoomGame = RoomAPI.createRoomGame;
export const completeMonth = RoomAPI.completeMonth;

export const updatePurchases = PurchaseAPI.updatePurchases;

export const getUserProfile = UserAPI.getUserProfile;
export const addFriends = UserAPI.addFriends;
export const removeFromFriends = UserAPI.removeFromFriends;

export const setOnlineStatus = MultiplayerAPI.setOnlineStatus;
export const getOnlineProfiles = MultiplayerAPI.getOnlineProfiles;

export const scheduledUpdateOfRecommendationBooks =
  RecommendationsAPI.scheduledRecommendationBooksUpdate;

Debug.initializeTestDataIfEmulator();
