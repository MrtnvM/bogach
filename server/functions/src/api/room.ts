import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { RoomService } from '../services/room_service';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';
import { FirebaseMessaging } from '../core/firebase/firebase_messaging';
import { UserProvider } from '../providers/user_provider';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameProvider = new GameProvider(firestore, selector);
  const userProvider = new UserProvider(firestore, selector);
  const firebaseMessaging = new FirebaseMessaging();
  const roomService = new RoomService(gameProvider, userProvider, firebaseMessaging);

  const createRoom = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const gameTemplateId = apiRequest.jsonField('gameTemplateId');
    const currentUserId = apiRequest.jsonField('currentUserId');

    const createRoomRequest = roomService.createRoom(gameTemplateId, currentUserId);

    await send(createRoomRequest, response);
    return Promise.resolve();
  });

  const setRoomParticipantReady = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const roomId = apiRequest.jsonField('roomId');
    const participantId = apiRequest.jsonField('participantId');

    const setReadyStatusRequest = roomService.onParticipantReady(roomId, participantId);
    await send(setReadyStatusRequest, response);
    return Promise.resolve();
  });

  const createRoomGame = https.onRequest(async (request, response) => {
    const apiRequest = APIRequest.from(request, response);
    apiRequest.checkMethod('POST');

    const roomId = apiRequest.jsonField('roomId');

    const createRoomRequest = roomService.createRoomGame(roomId);
    await send(createRoomRequest, response);
    return Promise.resolve();
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
  };
};
