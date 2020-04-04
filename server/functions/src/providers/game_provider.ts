import * as udid from 'uuid';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { Game, GameEntity } from '../models/domain/game/game';
import { GameTemplate, GameTemplateEntity } from '../models/domain/game/game_template';
import { UserEntity } from '../models/domain/user';
import { PossessionStateEntity } from '../models/domain/possession_state';
import { assertExists } from '../utils/asserts';

export class GameProvider {
  constructor(private firestore: Firestore, private selector: FirestoreSelector) {}

  async createGame(templateId: GameTemplateEntity.Id, userId: UserEntity.Id): Promise<Game> {
    const template = await this.getGameTemplate(templateId);

    if (!template) throw 'ERROR: No template on game creation';
    if (!userId) throw 'ERROR: No user ID on game creation';

    const gameId: GameEntity.Id = udid.v4();
    const game: Game = {
      id: gameId,
      name: template.name,
      participants: [userId],
      possessions: {
        [userId]: template.possessions,
      },
      possessionState: {
        [userId]: PossessionStateEntity.createEmpty(),
      },
      accounts: {
        [userId]: template.accountState,
      },
      target: template.target,
      currentEvents: [],
    };

    const selector = this.selector.game(gameId);
    const createdGame = await this.firestore.createItem(selector, game);

    GameEntity.validate(createdGame);
    return createdGame;
  }

  async getAllGames(): Promise<Game[]> {
    const selector = this.selector.games();
    const games = await this.firestore.getItems(selector);

    games.forEach(GameEntity.validate);
    return games as Game[];
  }

  async getGame(gameId: GameEntity.Id): Promise<Game> {
    assertExists('Game ID', gameId);

    const selector = this.selector.game(gameId);
    const game = (await this.firestore.getItem(selector)).data();

    GameEntity.validate(game);
    return game as Game;
  }

  async updateGame(game: Game): Promise<Game> {
    assertExists('Game and Game ID', game?.id);
    GameEntity.validate(game);

    const selector = this.selector.game(game.id);
    const updatedGame = (await this.firestore.getItem(selector)).data();

    GameEntity.validate(updatedGame);
    return game as Game;
  }

  async deleteGame(gameId: GameEntity.Id): Promise<void> {
    assertExists('Game ID', gameId);

    const selector = this.selector.game(gameId);
    await this.firestore.removeItem(selector);
  }

  async getAllGameTemplates(): Promise<GameTemplate[]> {
    const selector = this.selector.gameTemplates();
    const templates = await this.firestore.getItems(selector);

    templates.forEach(GameTemplateEntity.validate);
    return templates as GameTemplate[];
  }

  async getGameTemplate(templateId: GameTemplateEntity.Id): Promise<GameTemplate> {
    const selector = this.selector.gameTemplate(templateId);
    const template = (await this.firestore.getItem(selector)).data();

    GameTemplateEntity.validate(template);
    return template as GameTemplate;
  }
}
