import * as uuid from 'uuid';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { Game, GameEntity } from '../models/domain/game/game';
import { RoomEntity, Room } from '../models/domain/room';
import { GameTemplate, GameTemplateEntity } from '../game_templates/models/game_template';
import { UserEntity, User } from '../models/domain/user';
import { PossessionStateEntity } from '../models/domain/possession_state';
import { assertExists } from '../utils/asserts';
import { createParticipantsGameState } from '../models/domain/game/participant_game_state';
import { produce } from 'immer';
import { checkIds, checkId } from '../core/validation/type_checks';
import {
  applyGameTransformers,
  GameEventsTransformer,
  PossessionStateTransformer,
  MonthResultTransformer,
  StocksInitializerGameTransformer,
  DebentureInitializerGameTransformer,
} from '../transformers/game_transformers';
import { GameLevel, GameLevelEntity } from '../game_levels/models/game_level';
import { firestore as FirestoreAdmin } from 'firebase-admin';
import { GameTemplatesProvider } from './game_templates_provider';

export class GameProvider {
  constructor(
    private firestore: Firestore,
    private selector: FirestoreSelector,
    private gameTemplateProvider: GameTemplatesProvider
  ) {}

  async createGame(
    templateId: GameTemplateEntity.Id,
    participantsIds: UserEntity.Id[]
  ): Promise<Game> {
    this.checkParticipantsIds(participantsIds);

    const template = this.getGameTemplate(templateId);
    return this.createGameByTemplate(template, participantsIds);
  }

  async createGameByTemplate(
    template: GameTemplate,
    participantsIds: UserEntity.Id[],
    level?: GameLevel
  ): Promise<Game> {
    this.checkParticipantsIds(participantsIds);

    const participantsGameState = <T>(value: T) => {
      return createParticipantsGameState(participantsIds, value);
    };

    const gameId: GameEntity.Id = uuid.v4();
    const gameType: GameEntity.Type = participantsIds.length > 1 ? 'multiplayer' : 'singleplayer';

    let game: Game = {
      id: gameId,
      name: template.name,
      type: gameType,
      state: {
        moveStartDateInUTC: new Date().toISOString(),
        gameStatus: 'players_move',
        monthNumber: 1,
        participantsProgress: participantsGameState({
          status: 'player_move',
          currentEventIndex: 0,
          currentMonthForParticipant: 1,
          monthResults: {},
          progress: 0,
        }),
        winners: {},
      },
      participants: participantsIds,
      possessions: participantsGameState(template.possessions),
      possessionState: participantsGameState(PossessionStateEntity.createEmpty()),
      accounts: participantsGameState(template.accountState),
      target: template.target,
      currentEvents: [],
      history: { months: [] },
      config: {
        level: level?.id || null,
        monthLimit: level?.monthLimit || null,
        stocks: [],
        debentures: [],
        initialCash: template.accountState.cash,
        gameTemplateId: template.id,
      },
    };

    game = applyGameTransformers(game, [
      new StocksInitializerGameTransformer(),
      new DebentureInitializerGameTransformer(),
      new GameEventsTransformer(true),
      new PossessionStateTransformer(),
      new MonthResultTransformer(0),
    ]);

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
    const game = await this.firestore.getItemData(selector);

    GameEntity.validate(game);
    return game as Game;
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
    const templates = this.gameTemplateProvider.getGameTemplates();
    templates.forEach(GameTemplateEntity.validate);
    return templates;
  }

  getGameTemplate(templateId: GameTemplateEntity.Id): GameTemplate {
    const template = this.gameTemplateProvider.getGameTemplate(templateId);

    if (template?.id === undefined) {
      throw new Error('ERROR: No template with id: ' + templateId);
    }

    GameTemplateEntity.validate(template);
    return template;
  }

  async getRoom(roomId: RoomEntity.Id): Promise<Room> {
    const selector = this.selector.room(roomId);
    const room = await this.firestore.getItemData(selector);

    if (!room) {
      throw new Error('ERROR: No room with id: ' + roomId);
    }

    RoomEntity.validate(room);
    return room as Room;
  }

  async updateRoom(room: Room): Promise<Room> {
    assertExists('Room and Room ID', room?.id);
    RoomEntity.validate(room);

    const selector = this.selector.room(room.id);
    const updatedRoom = await this.firestore.updateItem(selector, room);

    RoomEntity.validate(updatedRoom);
    return updatedRoom as Room;
  }

  async createRoom(
    gameTemplateId: GameTemplateEntity.Id,
    currentUserId: UserEntity.Id
  ): Promise<Room> {
    checkIds([gameTemplateId, currentUserId]);

    const ownerSelector = this.selector.user(currentUserId);
    const owner = (await this.firestore.getItemData(ownerSelector)) as User;

    const ownerParticipant: RoomEntity.Participant = {
      id: currentUserId,
      status: 'ready',
      deviceToken: null,
    };

    const participants: RoomEntity.Participant[] = [ownerParticipant];

    const roomId: RoomEntity.Id = uuid.v4();
    const room: Room = {
      id: roomId,
      gameTemplateId,
      owner,
      participants,
    };

    const selector = this.selector.room(roomId);
    const createdRoom = await this.firestore.createItem(selector, room);

    RoomEntity.validate(createdRoom);
    return createdRoom;
  }

  async setParticipantReady(roomId: RoomEntity.Id, participantId: UserEntity.Id): Promise<Room> {
    const selector = this.selector.room(roomId);
    let room = (await this.firestore.getItemData(selector)) as Room;
    RoomEntity.validate(room);

    room = produce(room, (draft) => {
      const participantIndex = draft.participants.findIndex((p) => p.id === participantId);

      if (participantIndex >= 0) {
        draft.participants[participantIndex].status = 'ready';
      }
    });

    const updatedRoom = await this.firestore.updateItem(selector, room);
    return updatedRoom;
  }

  async createRoomGame(roomId: RoomEntity.Id): Promise<[Room, Game]> {
    checkId(roomId);

    const selector = this.selector.room(roomId);
    let room = (await this.firestore.getItemData(selector)) as Room;
    RoomEntity.validate(room);

    if (room.gameId !== undefined) {
      throw new Error('ERROR: Game already created');
    }

    const participantIds = room.participants //
      .filter((p) => p.status === 'ready')
      .map((p) => p.id);

    if (participantIds.length < 2) {
      throw new Error("ERROR: Multiplayer game can't have lower than 2 participants");
    }

    const game = await this.createGame(room.gameTemplateId, participantIds);

    room = produce(room, (draft) => {
      draft.gameId = game.id;
    });

    RoomEntity.validate(room);
    const updatedRoom = await this.firestore.updateItem(selector, room);

    return [updatedRoom, game];
  }

  private checkParticipantsIds(participantsIds: any) {
    if (!Array.isArray(participantsIds) || !participantsIds || participantsIds.length === 0) {
      throw new Error('ERROR: No participants IDs on game creation');
    }
  }
}
