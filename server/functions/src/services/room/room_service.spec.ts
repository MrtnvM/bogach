/// <reference types="@types/jest"/>

import { produce } from 'immer';
import { mock, instance, when, capture, reset } from 'ts-mockito';
import { GameProvider } from '../../providers/game_provider';
import { RoomService } from './room_service';
import { TestData } from '../game/game_service.multiplayer.spec.utils';
import { UserProvider } from '../../providers/user_provider';
import { TimerProvider } from '../../providers/timer_provider';
import { FirebaseMessaging } from '../../core/firebase/firebase_messaging';
import { Room } from '../../models/domain/room';

describe('Room Service', () => {
  const mockGameProvider = mock(GameProvider);
  const mockUserProvider = mock(UserProvider);
  const mockTimerProvider = mock(TimerProvider);
  const mockFirebaseMessaging = mock(FirebaseMessaging);

  let roomService: RoomService;

  beforeEach(() => {
    reset(mockGameProvider);
    reset(mockUserProvider);
    reset(mockTimerProvider);
    reset(mockFirebaseMessaging);

    roomService = new RoomService(
      instance(mockGameProvider),
      instance(mockUserProvider),
      instance(mockTimerProvider),
      instance(mockFirebaseMessaging)
    );
  });

  test('Successfully start timer on creating game', async () => {
    const moveStartDateInUTC = new Date().toISOString();
    const game = produce(TestData.game, (draft) => {
      draft.state.moveStartDateInUTC = moveStartDateInUTC;
    });

    const roomId = 'room1';
    const room: Room = {
      id: roomId,
      gameTemplateId: 'game_template1',
      owner: {
        userId: 'user1',
        userName: 'User 1',
        avatarUrl: '',
      },
      participants: [
        {
          id: 'user1',
          status: 'ready',
          deviceToken: null,
        },
        {
          id: 'user2',
          status: 'ready',
          deviceToken: null,
        },
      ],
    };

    when(mockGameProvider.createRoomGame(roomId)).thenResolve([room, game]);

    await roomService.createRoomGame(roomId);
    const [timerParams] = capture(mockTimerProvider.scheduleTimer).last();

    expect(timerParams).toEqual({
      startDateInUTC: moveStartDateInUTC,
      gameId: game.id,
      monthNumber: 1,
    });
  });
});
