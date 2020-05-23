import * as udid from 'uuid';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { Game, GameEntity } from '../models/domain/game/game';
import { GameTemplate, GameTemplateEntity } from '../models/domain/game/game_template';
import { UserEntity } from '../models/domain/user';
import { PossessionStateEntity } from '../models/domain/possession_state';
import { assertExists } from '../utils/asserts';
import { createParticipantsGameState } from '../models/domain/game/participant_game_state';

export class GameProvider {
  constructor(private firestore: Firestore, private selector: FirestoreSelector) {}

  async createGame(
    templateId: GameTemplateEntity.Id,
    participantsIds: UserEntity.Id[]
  ): Promise<Game> {
    if (!Array.isArray(participantsIds) || !participantsIds || participantsIds.length === 0) {
      throw new Error('ERROR: No participants IDs on game creation');
    }

    const template = await this.getGameTemplate(templateId);

    if (!template) {
      throw new Error('ERROR: No template on game creation');
    }

    const participantsGameState = <T>(value: T) => {
      return createParticipantsGameState(participantsIds, value);
    };

    const gameId: GameEntity.Id = udid.v4();
    const gameType: GameEntity.Type = participantsIds.length > 0 ? 'multiplayer' : 'singleplayer';

    const game: Game = {
      id: gameId,
      name: template.name,
      type: gameType,
      state: {
        gameStatus: 'players_move',
        monthNumber: 1,
        participantProgress: participantsGameState(0),
        winners: {},
      },
      participants: participantsIds,
      possessions: participantsGameState(template.possessions),
      possessionState: participantsGameState(PossessionStateEntity.createEmpty()),
      accounts: participantsGameState(template.accountState),
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
    const updatedGame = await this.firestore.updateItem(selector, game);

    GameEntity.validate(updatedGame);
    return updatedGame as Game;
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
