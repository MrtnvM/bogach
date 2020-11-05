import * as uuid from 'uuid';
import { Game, GameEntity } from '../models/domain/game/game';
import { RoomEntity, Room } from '../models/domain/room';
import { GameTemplate, GameTemplateEntity } from '../game_templates/models/game_template';
import { UserEntity } from '../models/domain/user/user';
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
import { GameLevel } from '../game_levels/models/game_level';
import { GameTemplatesProvider } from './game_templates_provider';
import { IGameDAO } from '../dao/game_dao';
import { IRoomDAO } from '../dao/room_dao';
import { IUserDAO } from '../dao/user_dao';
import { LastGameInfo, LastGamesEntity } from '../models/domain/user/last_games';

export class GameProvider {
  constructor(
    private gameDao: IGameDAO,
    private roomDao: IRoomDAO,
    private userDao: IUserDAO,
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
        winners: [],
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

    const createdGame = await this.gameDao.createGame(game);
    await this.updateGameParticipantsLastGames(createdGame, template);

    return createdGame;
  }

  getGame(gameId: GameEntity.Id): Promise<Game> {
    assertExists('Game ID', gameId);
    return this.gameDao.getGame(gameId);
  }

  updateGame(game: Game): Promise<Game> {
    assertExists('Game and Game ID', game?.id);
    return this.gameDao.updateGame(game);
  }

  deleteGame(gameId: GameEntity.Id): Promise<void> {
    assertExists('Game ID', gameId);
    return this.gameDao.deleteGame(gameId);
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

  getRoom(roomId: RoomEntity.Id): Promise<Room> {
    return this.roomDao.getRoom(roomId);
  }

  async updateRoom(room: Room): Promise<Room> {
    assertExists('Room and Room ID', room?.id);
    return this.roomDao.updateRoom(room);
  }

  async createRoom(
    gameTemplateId: GameTemplateEntity.Id,
    currentUserId: UserEntity.Id
  ): Promise<Room> {
    checkIds([gameTemplateId, currentUserId]);

    const owner = await this.userDao.getUser(currentUserId);
    const room = await this.roomDao.createRoom(gameTemplateId, owner);

    return room;
  }

  async setParticipantReady(roomId: RoomEntity.Id, participantId: UserEntity.Id): Promise<Room> {
    let room = await this.roomDao.getRoom(roomId);
    RoomEntity.validate(room);

    room = produce(room, (draft) => {
      const participantIndex = draft.participants.findIndex((p) => p.id === participantId);

      if (participantIndex >= 0) {
        draft.participants[participantIndex].status = 'ready';
      }
    });

    const updatedRoom = await this.roomDao.updateRoom(room);
    return updatedRoom;
  }

  async createRoomGame(roomId: RoomEntity.Id): Promise<[Room, Game]> {
    checkId(roomId);

    let room = await this.roomDao.getRoom(roomId);
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

    const updatedRoom = await this.roomDao.updateRoom(room);
    return [updatedRoom, game];
  }

  async updateGameParticipantsLastGames(game: Game, template: GameTemplate): Promise<void> {
    const updateProfileOperations = game.participants.map(async (participantId) => {
      const user = await this.userDao.getUser(participantId);
      if (!user) {
        return;
      }

      let lastGames = user.lastGames || LastGamesEntity.initial();
      let existingGame: LastGameInfo | undefined;

      const newLastGame: LastGameInfo = {
        gameId: game.id,
        templateId: template.id,
        createdAt: game.createdAt,
      };

      const isSingleplayerGame = game.type === 'singleplayer' && !game.config.level;
      if (isSingleplayerGame) {
        existingGame = lastGames.singleplayerGames.find((g) => g.templateId === template.id);

        lastGames = produce(lastGames, (draft) => {
          draft.singleplayerGames = lastGames.singleplayerGames.filter(
            (g) => g.gameId !== existingGame?.gameId
          );
          draft.singleplayerGames.push(newLastGame);
        });
      }

      const isQuestGame = game.type === 'singleplayer' && game.config.level;
      if (isQuestGame) {
        existingGame = lastGames.questGames.find((g) => g.templateId === template.id);

        lastGames = produce(lastGames, (draft) => {
          draft.questGames = lastGames.questGames.filter((g) => g.gameId !== existingGame?.gameId);
          draft.questGames.push(newLastGame);
        });
      }

      const isMultiplayerGame = game.type === 'multiplayer';
      if (isMultiplayerGame) {
        existingGame = lastGames.multiplayerGames.find((g) => g.templateId === template.id);

        lastGames = produce(lastGames, (draft) => {
          draft.multiplayerGames = lastGames.multiplayerGames.filter(
            (g) => g.gameId !== existingGame?.gameId
          );
          draft.multiplayerGames.push(newLastGame);
        });
      }

      if (existingGame) {
        await this.gameDao.deleteGame(existingGame.gameId);
      }

      const updatedProfile = produce(user, (draft) => {
        draft.lastGames = lastGames;
      });

      await this.userDao.updateUserProfile(updatedProfile);
    });

    await Promise.all(updateProfileOperations);
  }

  private checkParticipantsIds(participantsIds: any) {
    if (!Array.isArray(participantsIds) || !participantsIds || participantsIds.length === 0) {
      throw new Error('ERROR: No participants IDs on game creation');
    }
  }
}
