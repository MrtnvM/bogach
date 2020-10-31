import { IGameDAO } from '../game_dao';
import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { GameLevelEntity } from '../../game_levels/models/game_level';
import { RealtimeDatabase } from '../../core/firebase/realtime_database';
import { RealtimeDatabaseRefs } from './realtime_database_refs';
import produce from 'immer';

export class RealtimeDatabaseGameDAO implements IGameDAO {
  constructor(private refs: RealtimeDatabaseRefs, private db: RealtimeDatabase) {}

  async createGame(game: Game): Promise<Game> {
    const selector = this.refs.game(game.id);
    const createdGame = await this.db.createItem(selector, game);
    GameEntity.validate(createdGame);
    return createdGame;
  }

  async getGames(): Promise<Game[]> {
    const selector = this.refs.games();
    const games = await this.db.getValue(selector);
    games.forEach(GameEntity.validate);
    return games as Game[];
  }

  async getGame(gameId: string): Promise<Game> {
    const selector = this.refs.game(gameId);
    const game = (await this.db.getValue(selector)) as Game;

    const normalizedGame = produce(game, (draft) => {
      draft.participants = draft.participants || [];
      draft.currentEvents = draft.currentEvents || [];
      draft.state.winners = draft.state.winners || [];
      draft.history.months = draft.history.months || [];

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

  async updateGame(game: Game): Promise<Game> {
    GameEntity.validate(game);

    const selector = this.refs.game(game.id);
    const updatedGame = await this.db.updateItem(selector, game);

    GameEntity.validate(updatedGame);
    return updatedGame as Game;
  }

  async deleteGame(gameId: string): Promise<void> {
    const selector = this.refs.game(gameId);
    await this.db.removeItem(selector);
  }

  async getUserQuestGames(userId: UserEntity.Id, levelIds: GameLevelEntity.Id[]): Promise<Game[]> {
    throw new Error('Not implemented');
  }

  async removeUserQuestGamesForLevel(
    userId: UserEntity.Id,
    levelId: GameLevelEntity.Id
  ): Promise<void> {
    throw new Error('Not implemented');
  }
}
