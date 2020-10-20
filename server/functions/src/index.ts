import * as admin from 'firebase-admin';

import * as gameAPI from './api/game';
import * as roomAPI from './api/room';
import * as purchaseAPI from './api/purchase';
import * as userAPI from './api/user';

import { FirestoreSelector } from './providers/firestore_selector';
import { Firestore } from './core/firebase/firestore';
import { getDatabaseURL, getStorageBucket } from './config';

admin.initializeApp({
  databaseURL: getDatabaseURL(),
  storageBucket: getStorageBucket(),
});

const selector = new FirestoreSelector(admin.firestore());
const firestore = new Firestore();

const GameAPI = gameAPI.create(firestore, selector);
const RoomAPI = roomAPI.create(firestore, selector);
const PurchaseAPI = purchaseAPI.create(firestore, selector);
const UserAPI = userAPI.create(firestore, selector);

export const createGame = GameAPI.create;
export const getGame = GameAPI.getGame;
export const getAllGames = GameAPI.getAllGames;
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
