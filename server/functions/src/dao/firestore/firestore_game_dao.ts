import { IGameDAO } from '../game_dao';
import { Game, GameEntity } from '../../models/domain/game/game';
import { FirestoreSelector } from '../../providers/firestore_selector';
import { Firestore } from '../../core/firebase/firestore';

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

  updateGameForUser(game: Game, userId: string): Promise<void> {
    throw new Error('Method not implemented.');
  }

  async deleteGame(gameId: string): Promise<void> {
    const selector = this.selector.game(gameId);
    await this.firestore.removeItem(selector);
  }
}
