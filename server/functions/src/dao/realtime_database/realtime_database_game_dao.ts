import produce from 'immer';
import { IGameDAO } from '../game_dao';
import { Game, GameEntity } from '../../models/domain/game/game';
import { RealtimeDatabase } from '../../core/firebase/realtime_database';
import { RealtimeDatabaseRefs } from './realtime_database_refs';

export class RealtimeDatabaseGameDAO implements IGameDAO {
  constructor(private refs: RealtimeDatabaseRefs, private db: RealtimeDatabase) {}

  async getGame(gameId: string): Promise<Game> {
    const selector = this.refs.game(gameId);
    const game = (await this.db.getValue(selector)) as Game;

    const normalizedGame = produce(game, (draft) => {
      draft.participants = draft.participants || [];
      draft.currentEvents = draft.currentEvents || [];
      draft.state.winners = draft.state.winners || [];

      const initialHistory: GameEntity.History = { months: [] };
      draft.history = draft.history || initialHistory;
      draft.history.months.forEach((m) => {
        m.events = m.events || [];
      });

      draft.participants.forEach((participantId) => {
        const possessionState = draft.possessionState[participantId];
        possessionState.incomes = possessionState.incomes || [];
        possessionState.expenses = possessionState.expenses || [];
        possessionState.assets = possessionState.assets || [];
        possessionState.liabilities = possessionState.liabilities || [];

        const possessions = draft.possessions[participantId];
        possessions.incomes = possessions.incomes || [];
        possessions.expenses = possessions.expenses || [];
        possessions.assets = possessions.assets || [];
        possessions.liabilities = possessions.liabilities || [];
      });
    });

    GameEntity.validate(normalizedGame);
    return normalizedGame;
  }

  async createGame(game: Game): Promise<Game> {
    const selector = this.refs.game(game.id);
    const createdGame = await this.db.createItem(selector, game);
    GameEntity.validate(createdGame);
    return createdGame;
  }

  async updateGame(game: Game): Promise<Game> {
    GameEntity.validate(game);

    const selector = this.refs.game(game.id);
    const updatedGame = await this.db.updateItem(selector, game);

    GameEntity.validate(updatedGame);
    return updatedGame as Game;
  }

  async updateGameForUser(game: Game, userId: string): Promise<void> {
    GameEntity.validate(game);

    const progress = game.state.participantsProgress[userId];
    const progressRef = this.refs.participantProgress(userId, game.id);
    const updateProgressOperation = this.db.updateItem(progressRef, progress);

    const possessions = game.possessions[userId];
    const possessionsRef = this.refs.possessions(userId, game.id);
    const updatePossessionsOperation = this.db.updateItem(possessionsRef, possessions);

    const possessionState = game.possessionState[userId];
    const possessionStateRef = this.refs.possessionState(userId, game.id);
    const updatePossessionStateOperation = this.db.updateItem(possessionStateRef, possessionState);

    const account = game.accounts[userId];
    const accountRef = this.refs.participantAccount(userId, game.id);
    const updateAccountOperation = this.db.updateItem(accountRef, account);

    await Promise.all([
      updateProgressOperation,
      updatePossessionsOperation,
      updatePossessionStateOperation,
      updateAccountOperation,
    ]);
  }

  async deleteGame(gameId: string): Promise<void> {
    const selector = this.refs.game(gameId);
    await this.db.removeItem(selector);
  }
}
