import * as uuid from 'uuid';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from './firestore_selector';
import { Game, GameEntity } from '../models/domain/game/game';
import { RoomEntity, Room } from '../models/domain/room';
import { GameTemplate, GameTemplateEntity } from '../models/domain/game/game_template';
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
} from '../transformers/game_transformers';

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

    const gameId: GameEntity.Id = uuid.v4();
    const gameType: GameEntity.Type = participantsIds.length > 1 ? 'multiplayer' : 'singleplayer';

    let game: Game = {
      id: gameId,
      name: template.name,
      type: gameType,
      state: {
        gameStatus: 'players_move',
        monthNumber: 1,
        participantProgress: participantsGameState(0),
        participantsProgress: participantsGameState({
          status: 'player_move',
          currentEventIndex: 0,
          currentMonthForParticipant: 1,
          monthResults: {},
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
      config: { stocks: [] },
    };

    game = applyGameTransformers(game, [
      new StocksInitializerGameTransformer(),
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
    const templates = (await this.firestore.getItems(selector)) || [];

    templates.forEach(GameTemplateEntity.validate);
    return templates as GameTemplate[];
  }

  async createGameTemplate(template: GameTemplate): Promise<GameTemplate> {
    const selector = this.selector.gameTemplate(template.id);
    const createdTemplate = await this.firestore.createItem(selector, template);

    GameTemplateEntity.validate(createdTemplate);
    return createdTemplate as GameTemplate;
  }

  async getGameTemplate(templateId: GameTemplateEntity.Id): Promise<GameTemplate> {
    const selector = this.selector.gameTemplate(templateId);
    const template = await this.firestore.getItemData(selector);

    if (!template) {
      throw new Error('ERROR: No template with id: ' + templateId);
    }

    GameTemplateEntity.validate(template);
    return template as GameTemplate;
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

    const participantIds = room.participants.filter((p) => p.status === 'ready').map((p) => p.id);

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
}
