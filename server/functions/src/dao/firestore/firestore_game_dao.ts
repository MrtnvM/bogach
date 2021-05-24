import { IGameDAO } from '../game_dao';
import { Game, GameEntity } from '../../models/domain/game/game';
import { FirestoreSelector } from '../../providers/firestore_selector';
import { Firestore } from '../../core/firebase/firestore';
import { GameTemplateEntity } from '../../game_templates/models/game_template';
import { LevelStatistic } from '../../models/domain/level_statistic/level_statistic';

export class FirestoreGameDAO implements IGameDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async createGame(game: Game): Promise<Game> {
    const selector = this.selector.game(game.id);
    const createdGame = await this.firestore.createItem(selector, game);
    GameEntity.validate(createdGame);
    return createdGame;
  }

  async getGame(gameId: string): Promise<Game> {
    const selector = this.selector.game(gameId);
    const game = await this.firestore.getItemData(selector);

    GameEntity.validate(game);
    return game as Game;
  }

  async updateGame(game: Game): Promise<Game> {
    GameEntity.validate(game);

    const selector = this.selector.game(game.id);
    const updatedGame = await this.firestore.updateItem(selector, game);

    GameEntity.validate(updatedGame);
    return updatedGame as Game;
  }

  updateGameWithoutParticipants(game: Game): Promise<void> {
    throw new Error('Method not implemented.');
  }

  updateParticipant(game: Game, userId: string): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async deleteGame(gameId: string): Promise<void> {
    const selector = this.selector.game(gameId);
    await this.firestore.removeItem(selector);
  }

  async updateLevelStatistic(statistic: LevelStatistic): Promise<LevelStatistic> {
    LevelStatistic.validate(statistic);

    const selector = this.selector.levelStatistic(statistic.id);
    const updatedStatistic = await this.firestore.updateItem(selector, statistic);
    
    return updatedStatistic as LevelStatistic;
  }

  async getLevelStatistic(templateId: GameTemplateEntity.Id): Promise<LevelStatistic> {
    const selector = this.selector.levelStatistic(templateId);
    const statistic = await this.firestore.getItemData(selector) || {};

    LevelStatistic.validate(statistic);

    return statistic as LevelStatistic;
  }
}
