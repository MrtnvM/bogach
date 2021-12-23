import * as uuid from 'uuid';
import { Game, GameEntity } from '../models/domain/game/game';
import { RoomEntity, Room } from '../models/domain/room';
import { GameTemplate, GameTemplateEntity } from '../game_templates/models/game_template';
import { UserEntity } from '../models/domain/user/user';
import { PossessionStateEntity } from '../models/domain/possession_state';
import { assertExists } from '../utils/asserts';
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
import { ILevelStatisticDAO } from '../dao/level_statistic_dao';
import { LevelStatistic } from '../models/domain/level_statistic/level_statistic';

export class GameProvider {
  constructor(
    private gameDao: IGameDAO,
    private roomDao: IRoomDAO,
    private userDao: IUserDAO,
    private levelStatisticDao: ILevelStatisticDAO,
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

    const gameId: GameEntity.Id = uuid.v4();
    const gameType: GameEntity.Type = participantsIds.length > 1 ? 'multiplayer' : 'singleplayer';

    const participants: { [userId: string]: GameEntity.Participant } = {};
    participantsIds.forEach((id) => {
      const participant: GameEntity.Participant = {
        id,
        possessions: template.possessions,
        possessionState: PossessionStateEntity.createEmpty(),
        account: template.accountState,
        progress: {
          status: 'player_move',
          currentEventIndex: 0,
          currentMonthForParticipant: 1,
          monthResults: {},
          progress: 0,
        },
      };

      participants[id] = participant;
    });

    let game: Game = {
      id: gameId,
      name: template.name,
      type: gameType,
      participantsIds,
      participants,
      state: {
        moveStartDateInUTC: new Date().toISOString(),
        gameStatus: 'players_move',
        monthNumber: 1,
        winners: [],
      },
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

  updateGameWithoutParticipants(game: Game): Promise<void> {
    assertExists('Game and Game ID', game?.id);
    return this.gameDao.updateGameWithoutParticipants(game);
  }

  updateGameForUser(game: Game, userId: UserEntity.Id): Promise<void> {
    assertExists('Game and Game ID', game?.id);
    return this.gameDao.updateParticipant(game, userId);
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
    const updateProfileOperations = game.participantsIds.map(async (participantId) => {
      const user = await this.userDao.getUser(participantId);
      if (!user) {
        throw new Error('ERROR: Can not find the user with id:' + participantId);
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

  async updateGameParticipantsCompletedGames(game: Game): Promise<void> {
    const updateProfileOperations = game.participantsIds.map(async (participantId) => {
      const user = await this.userDao.getUser(participantId);
      if (!user) {
        throw new Error('ERROR: Can not find the user with id:' + participantId);
        return;
      }

      const templateId = game.config.gameTemplateId;

      let completedGames = user.completedGames || LastGamesEntity.initial();
      let existingGame: LastGameInfo | undefined;

      const newLastGame: LastGameInfo = {
        gameId: game.id,
        templateId: templateId,
        createdAt: game.createdAt,
      };

      const isWinner =
        game.state.winners.find(
          (winner) => winner.userId === user.userId && winner.targetValue >= 1
        ) !== undefined;

      const isSingleplayerGame = game.type === 'singleplayer' && !game.config.level && isWinner;
      if (isSingleplayerGame) {
        existingGame = completedGames.singleplayerGames.find((g) => g.templateId === templateId);

        completedGames = produce(completedGames, (draft) => {
          draft.singleplayerGames = completedGames.singleplayerGames.filter(
            (g) => g.gameId !== existingGame?.gameId && g.createdAt !== undefined
          );

          draft.singleplayerGames.push(newLastGame);
        });

        const statistic = await this.levelStatisticDao.getLevelStatistic(templateId);
        const updatedStatistic = produce(statistic, (draft) => {
          draft.statistic[user.userId] = game.state.monthNumber;
        });

        await this.levelStatisticDao.updateLevelStatistic(updatedStatistic);
      }

      const isQuestGame = game.type === 'singleplayer' && game.config.level && isWinner;
      if (isQuestGame) {
        existingGame = completedGames.questGames.find((g) => g.templateId === templateId);

        completedGames = produce(completedGames, (draft) => {
          draft.questGames = completedGames.questGames.filter(
            (g) => g.gameId !== existingGame?.gameId && g.createdAt !== undefined
          );

          draft.questGames.push(newLastGame);
        });
      }

      const isMultiplayerGame = game.type === 'multiplayer' && isWinner;
      if (isMultiplayerGame) {
        existingGame = completedGames.multiplayerGames.find((g) => g.templateId === templateId);

        completedGames = produce(completedGames, (draft) => {
          draft.multiplayerGames = completedGames.multiplayerGames.filter(
            (g) => g.gameId !== existingGame?.gameId && g.createdAt !== undefined
          );

          draft.multiplayerGames.push(newLastGame);
        });
      }

      const updatedProfile = produce(user, (draft) => {
        draft.completedGames = completedGames;
      });

      await this.userDao.updateUserProfile(updatedProfile);
    });

    await Promise.all(updateProfileOperations);
  }

  async updateLevelStatistic(game: Game): Promise<LevelStatistic> {
    const templateId = game.config.gameTemplateId;

    const updateStatisticOperations = game.participantsIds.map(async (userId) => {
      const isWinner =
        game.state.winners.find((winner) => winner.userId === userId && winner.targetValue >= 1) !==
        undefined;

      const isSingleplayerGame = game.type === 'singleplayer' && !game.config.level;

      if (isSingleplayerGame && isWinner) {
        const statistic = await this.levelStatisticDao.getLevelStatistic(templateId);

        const updatedStatistic = produce(statistic, (draft) => {
          draft.statistic[userId] = game.state.monthNumber;
        });

        await this.levelStatisticDao.updateLevelStatistic(updatedStatistic);
      }
    });

    await Promise.all(updateStatisticOperations);

    return this.levelStatisticDao.getLevelStatistic(templateId);
  }

  private checkParticipantsIds(participantsIds: any) {
    if (!Array.isArray(participantsIds) || !participantsIds || participantsIds.length === 0) {
      throw new Error('ERROR: No participants IDs on game creation');
    }
  }
}
