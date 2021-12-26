import * as express from 'express';

import { GameProvider } from '../providers/game_provider';
import { RoomService } from '../services/room/room_service';
import { APIRequest } from '../core/api/request_data';
import { FirebaseMessaging } from '../core/firebase/firebase_messaging';
import { UserProvider } from '../providers/user_provider';
import { GameService } from '../services/game/game_service';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { TimerProvider } from '../providers/timer_provider';
import { GameTemplatesProvider } from '../providers/game_templates_provider';
import { DAOs } from '../dao/daos';

export const initialize = (daos: DAOs, app: express.Express) => {
  const gameTemplatesProvider = new GameTemplatesProvider();
  const gameLevelProvider = new GameLevelsProvider();
  const gameProvider = new GameProvider(
    daos.game,
    daos.room,
    daos.user,
    daos.levelStatistic,
    gameTemplatesProvider
  );
  const userProvider = new UserProvider(daos.user);
  const timerProvider = new TimerProvider();
  const firebaseMessaging = new FirebaseMessaging();

  const roomService = new RoomService(gameProvider, userProvider, timerProvider, firebaseMessaging);
  const gameService = new GameService(gameProvider, gameLevelProvider, userProvider, timerProvider);

  app.post(
    '/createRoom',
    APIRequest.handle(async (apiRequest) => {
      const gameTemplateId = apiRequest.jsonField('gameTemplateId');
      const currentUserId = apiRequest.jsonField('currentUserId');
      const invitedUsers = apiRequest.optionalJsonField('invitedUsers') || [];

      const room = await roomService.createRoom(gameTemplateId, currentUserId, invitedUsers);
      return room;
    })
  );

  app.post(
    '/setRoomParticipantReady',
    APIRequest.handle(async (apiRequest) => {
      const roomId = apiRequest.jsonField('roomId');
      const participantId = apiRequest.jsonField('participantId');

      await roomService.onParticipantReady(roomId, participantId);
    })
  );

  app.post(
    '/createRoomGame',
    APIRequest.handle(async (apiRequest) => {
      const roomId = apiRequest.jsonField('roomId');

      const { room, game } = await roomService.createRoomGame(roomId);
      await gameService.reduceMultiplayerGames(
        room.participants.map((participant) => participant.id),
        game.id,
        (game.createdAt && new Date(game.createdAt).getTime()) || undefined
      );
      return room;
    })
  );

  app.post(
    '/completeMonth',
    APIRequest.handle(async (apiRequest) => {
      const gameId = apiRequest.jsonField('game_id');
      const monthNumber = apiRequest.jsonField('month_number');

      await gameService.completeMonth(gameId, monthNumber);
    })
  );
};
