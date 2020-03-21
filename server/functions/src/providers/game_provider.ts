import * as udid from 'uuid';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { Game, GameEntity } from '../models/domain/game/game';
import { GameEvent, GameEventId, GameEventEntity } from '../models/domain/game/game_event';
import { GameTemplate, GameTemplateEntity } from '../models/domain/game/game_template';
import { UserId } from '../models/domain/user';
import { PossessionStateEntity } from '../models/domain/possession_state';

export class GameProvider {
  constructor(private firestore: Firestore, private selector: FirestoreSelector) {}

  async createGame(templateId: GameTemplateEntity.Id, userId: UserId): Promise<Game> {
    const template = await this.getGameTemplate(templateId);

    if (!template) throw 'ERROR: No template on game creation';
    if (!userId) throw 'ERROR: No user ID on game creation';

    const gameId: GameEntity.Id = udid.v4();
    const game: Game = {
      id: gameId,
      name: template.name,
      participants: [userId],
      possessions: template.possessions, // TODO: Implement possession validation
      possessionState: PossessionStateEntity.createEmpty(),
      accounts: { userId: template.accountState },
      target: template.target,
      currentEvents: []
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
    const selector = this.selector.game(gameId);
    const game = (await this.firestore.getItem(selector)).data();

    GameEntity.validate(game);
    return game as Game;
  }

  async getGameEvent(eventId: GameEventId): Promise<GameEvent> {
    const selector = this.selector.gameEvent(eventId);
    const gameEvent = (await this.firestore.getItem(selector)).data();

    GameEventEntity.validate(gameEvent);
    return gameEvent as GameEvent;
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
