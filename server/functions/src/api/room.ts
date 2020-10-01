import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { RoomService } from '../services/room_service';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { FirebaseMessaging } from '../core/firebase/firebase_messaging';
import { UserProvider } from '../providers/user_provider';
import { GameService } from '../services/game_service';
import { GameLevelsProvider } from '../providers/game_levels_provider';
import { scheduleMonthEndTimer } from './external/timer';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameProvider = new GameProvider(firestore, selector);
  const gameLevelProvider = new GameLevelsProvider();
  const userProvider = new UserProvider(firestore, selector);
  const firebaseMessaging = new FirebaseMessaging();
  const roomService = new RoomService(gameProvider, userProvider, firebaseMessaging);
  const gameService = new GameService(gameProvider, gameLevelProvider, userProvider);

  const createRoom = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const gameTemplateId = apiRequest.jsonField('gameTemplateId');
    const currentUserId = apiRequest.jsonField('currentUserId');

    const createRoomRequest = roomService.createRoom(gameTemplateId, currentUserId);

    await send(createRoomRequest, response);
  });

  const setRoomParticipantReady = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const roomId = apiRequest.jsonField('roomId');
    const participantId = apiRequest.jsonField('participantId');

    const setReadyStatusRequest = roomService.onParticipantReady(roomId, participantId);
    await send(setReadyStatusRequest, response);
  });

  const createRoomGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const roomId = apiRequest.jsonField('roomId');

    const createRoomRequest = async () => {
      const room = await roomService.createRoomGame(roomId);

      await scheduleMonthEndTimer({
        startDate: new Date(),
        gameId: room.gameId || '',
        monthNumber: 1,
      });

      return room;
    };
    return send(createRoomRequest(), response);
  });

  const completeMonth = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const gameId = apiRequest.jsonField('game_id');
    const monthNumber = apiRequest.jsonField('month_number');

    const completeMonthRequest = gameService.completeMonth(gameId, monthNumber);
    return send(completeMonthRequest, response);
  });

  const send = <T>(data: Promise<T>, response: functions.Response) => {
    return data
      .then((result) => response.status(200).send(result))
      .catch((error) => {
        const errorMessage = error['message'] ? error.message : error;
        console.error('ERROR: ' + JSON.stringify(error));
        console.error('ERROR MESSAGE: ' + errorMessage);
        response.status(422).send(errorMessage);
      });
  };

  return {
    createRoom,
    setRoomParticipantReady,
    createRoomGame,
    completeMonth,
  };
};
