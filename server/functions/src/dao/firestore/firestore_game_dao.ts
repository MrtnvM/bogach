import { IGameDAO } from '../game_dao';
import { Game, GameEntity } from '../../models/domain/game/game';
import { FirestoreSelector } from '../../providers/firestore_selector';
import { Firestore } from '../../core/firebase/firestore';
import { UserEntity } from '../../models/domain/user';
import { GameLevelEntity } from '../../game_levels/models/game_level';
import { firestore as FirestoreAdmin } from 'firebase-admin';

export class FirestoreGameDAO implements IGameDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

  async createGame(game: Game): Promise<Game> {
    const selector = this.selector.game(game.id);
    const createdGame = await this.firestore.createItem(selector, game);
    GameEntity.validate(createdGame);
    return createdGame;
  }

  async getGames(): Promise<Game[]> {
    const selector = this.selector.games();
    const games = await this.firestore.getItems(selector);
    games.forEach(GameEntity.validate);
    return games as Game[];
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

  async deleteGame(gameId: string): Promise<void> {
    const selector = this.selector.game(gameId);
    await this.firestore.removeItem(selector);
  }

  async getUserQuestGames(userId: UserEntity.Id, levelIds: GameLevelEntity.Id[]): Promise<Game[]> {
    const selector = this.selector.games();

    const participantsKey: keyof Game = 'participants';
    const configKey: keyof Game = 'config';
    const levelKey: keyof GameEntity.Config = 'level';

    const query = selector
      .where(participantsKey, 'array-contains', userId)
      .where(`${configKey}.${levelKey}`, 'in', levelIds);

    const userQuestGamesQueryResult = await this.firestore.getQueryItems(query);
    userQuestGamesQueryResult.forEach(GameEntity.validate);

    const userQuestGames = userQuestGamesQueryResult as Game[];

    const userNotCompletedQuestGames = userQuestGames
      .filter((g) => g.state.gameStatus !== 'game_over')
      .sort((g1, g2) => {
        if (!g1.updatedAt || !g2.updatedAt) {
          return 0;
        }

        const timestamp1 = (g1.updatedAt as any) as FirestoreAdmin.Timestamp;
        const timestamp2 = (g2.updatedAt as any) as FirestoreAdmin.Timestamp;

        return timestamp2.seconds - timestamp1.seconds;
      });

    return userNotCompletedQuestGames;
  }

  async removeUserQuestGamesForLevel(
    userId: UserEntity.Id,
    levelId: GameLevelEntity.Id
  ): Promise<void> {
    const selector = this.selector.games();

    const participantsKey: keyof Game = 'participants';
    const configKey: keyof Game = 'config';
    const levelKey: keyof GameEntity.Config = 'level';

    const query = selector
      .where(participantsKey, 'array-contains', userId)
      .where(`${configKey}.${levelKey}`, 'in', [levelId]);

    const games = await query.get();
    const deleteQuestGameOperations = games.docs.map((d) => d.ref.delete());

    await Promise.all(deleteQuestGameOperations);
  }
}
