import * as admin from 'firebase-admin';

import * as gameAPI from './api/game';
import * as possessionAPI from './api/possessions';

import { FirestoreSelector } from './providers/firestore_selector';
import { Firestore } from './core/firebase/firestore';

admin.initializeApp();

const selector = new FirestoreSelector(admin.firestore());
const firestore = new Firestore();

const GameAPI = gameAPI.create(firestore, selector);
const PossessionAPI = possessionAPI.create(firestore, selector);

export const createGame = GameAPI.create;
export const getGame = GameAPI.getGame;
export const getAllGames = GameAPI.getAllGames;
export const getGameTemplate = GameAPI.getGameTemplate;
export const getAllGameTemplates = GameAPI.getAllGameTemplates;
export const generateGameEvents = GameAPI.generateGameEvents;
export const handleGameEvent = GameAPI.handleGameEvent;

export const updatePossessionState = PossessionAPI.updatePossessionsState;
