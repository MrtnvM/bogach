import produce from 'immer';
import { IGameDAO } from '../game_dao';
import { Game, GameEntity } from '../../models/domain/game/game';
import { RealtimeDatabase } from '../../core/firebase/realtime_database';
import { RealtimeDatabaseRefs } from './realtime_database_refs';
import { UserEntity } from '../../models/domain/user/user';

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

      const months: GameEntity.HistoryMonth[] = [];
      for (let i = 0; i < draft.state.monthNumber; i++) {
        const month = draft.history.months[i] ?? { events: [] };
        months.push(month);
      }

      draft.history.months = months;

      draft.participantsIds.forEach((participantId) => {
        const possessionState = draft.participants[participantId].possessionState;
        possessionState.incomes = possessionState.incomes || [];
        possessionState.expenses = possessionState.expenses || [];
        possessionState.assets = possessionState.assets || [];
        possessionState.liabilities = possessionState.liabilities || [];

        const possessions = draft.participants[participantId].possessions;
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

  async updateGame(game: Game, oldGame: Game): Promise<Game> {
    GameEntity.validate(game);

    const selector = this.refs.game(game.id);
    const updatedGame = await this.db.updateItem(selector, game, oldGame);

    GameEntity.validate(updatedGame);
    return updatedGame as Game;
  }

  async updateGameWithoutParticipants(game: Game, oldGame: Game): Promise<void> {
    GameEntity.validate(game);

    const newGame = { ...game, participants: undefined };
    delete newGame.participants;

    const oldGameData = { ...oldGame, participants: undefined };
    delete oldGameData.participants;

    const selector = this.refs.game(newGame.id);
    await this.db.updateItem(selector, newGame, oldGameData);
  }

  async updateParticipant(game: Game, oldGame: Game, userId: UserEntity.Id): Promise<void> {
    GameEntity.validate(game);

    const updatedParticipant = game.participants[userId];
    const oldParticipant = oldGame.participants[userId];
    const participantRef = this.refs.gameParticipant(userId, game.id);
    await this.db.updateItem(participantRef, updatedParticipant, oldParticipant);
  }

  async deleteGame(gameId: string): Promise<void> {
    const selector = this.refs.game(gameId);
    await this.db.removeItem(selector);
  }
}
