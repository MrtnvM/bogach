import * as admin from 'firebase-admin';

import * as gameAPI from './api/game';
import * as roomAPI from './api/room';
import * as testAPI from './api/test';

import { FirestoreSelector } from './providers/firestore_selector';
import { Firestore } from './core/firebase/firestore';

admin.initializeApp();

const selector = new FirestoreSelector(admin.firestore());
const firestore = new Firestore();

const GameAPI = gameAPI.create(firestore, selector);
const RoomAPI = roomAPI.create(firestore, selector);
const TestAPI = testAPI.create(firestore, selector);

export const createGame = GameAPI.create;
export const getGame = GameAPI.getGame;
export const getAllGames = GameAPI.getAllGames;
export const getGameTemplate = GameAPI.getGameTemplate;
export const getAllGameTemplates = GameAPI.getAllGameTemplates;
export const handleGameEvent = GameAPI.handleGameEvent;
export const startNewMonth = GameAPI.startNewMonth;

export const createRoom = RoomAPI.createRoom;
export const setRoomParticipantReady = RoomAPI.setRoomParticipantReady;
export const createRoomGame = RoomAPI.createRoomGame;

/// TEST API: Should be disabled when deploying to prod
export const initialiseTestData = TestAPI.initialiseTestData;
