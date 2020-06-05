import * as functions from 'firebase-functions';
import * as config from '../config';

import { GameProvider } from '../providers/game_provider';
import { GameService } from '../services/game_service';
import { APIRequest } from '../core/api/request_data';
import { Firestore } from '../core/firebase/firestore';
import { FirestoreSelector } from '../providers/firestore_selector';

export const create = (firestore: Firestore, selector: FirestoreSelector) => {
  const https = functions.region(config.CLOUD_FUNCTIONS_REGION).https;

  const gameProvider = new GameProvider(firestore, selector);
  const gameService = new GameService(gameProvider);

  const createRoom = https.onRequest(async (request, response) => {
    if (request.method !== 'POST') {
      response.status(400).send('ERROR: Request should use POST method');
      return;
    }

    const apiRequest = APIRequest.from(request);

    const gameTemplateId = apiRequest.jsonField('gameTemplateId');
    const participantsIds = apiRequest.jsonField('participantsIds');
    const currentUserId = apiRequest.jsonField('currentUserId');

    const createRoomRequest = gameService.createRoom(
      gameTemplateId,
      participantsIds,
      currentUserId
    );

    return send(createRoomRequest, response);
  });

  const setRoomParticipantReady = https.onRequest(async (request, response) => {
    if (request.method !== 'POST') {
      response.status(400).send('ERROR: Request should use POST method');
      return;
    }

    const apiRequest = APIRequest.from(request);

    const roomId = apiRequest.jsonField('roomId');
    const participantId = apiRequest.jsonField('participantId');

    const setReadyStatusRequest = gameService.onParticipantReady(roomId, participantId);
    return send(setReadyStatusRequest, response);
  });

  const createRoomGame = https.onRequest(async (request, response) => {
    if (request.method !== 'POST') {
      response.status(400).send('ERROR: Request should use POST method');
      return;
    }

    const apiRequest = APIRequest.from(request);

    const roomId = apiRequest.jsonField('roomId');

    const createRoomRequest = gameService.createRoomGame(roomId);
    return send(createRoomRequest, response);
  });

  const send = <T>(data: Promise<T>, response: functions.Response) => {
    return data
      .then((result) => response.status(200).send(result))
      .catch((error) => {
        const errorMessage = error['message'] ? error.message : error;
        response.status(422).send(errorMessage);
      });
  };

  return {
    createRoom,
    setRoomParticipantReady,
    createRoomGame,
  };
};
