import * as admin from 'firebase-admin';
import { GameProvider } from './providers/game_provider';
import * as gameAPI from './api/game';
import * as incomeAPI from './api/income';
import * as expenseAPI from './api/expenses';
import * as assetAPI from './api/assets';
import * as liabilityAPI from './api/liabilities';
import * as possessionAPI from './api/possessions';
import { FirestoreSelector } from './providers/firestore_selector';
import { Firestore } from './core/firebase/firestore';

admin.initializeApp();

const selector = new FirestoreSelector(admin.firestore());
const firestore = new Firestore();
const gameProvider = new GameProvider(firestore, selector);

const GameAPI = gameAPI.create(gameProvider);
const IncomeAPI = incomeAPI.create(firestore, selector);
const ExpenseAPI = expenseAPI.create(firestore, selector);
const AssetAPI = assetAPI.create(firestore, selector);
const LiabilityAPI = liabilityAPI.create(firestore, selector);
const PossessionAPI = possessionAPI.create(firestore, selector);

export const createGame = GameAPI.create;
export const getAllGames = GameAPI.getAll;

export const createIncome = IncomeAPI.create;
export const getAllIncomes = IncomeAPI.getAll;

export const createExpense = ExpenseAPI.create;
export const getAllExpenses = ExpenseAPI.getAll;

export const createAsset = AssetAPI.create;
export const getAllAssets = AssetAPI.getAll;

export const createLiability = LiabilityAPI.create;
export const getAllLiabilities = LiabilityAPI.getAll;

export const updatePossessionState = PossessionAPI.updatePossessionsState;
