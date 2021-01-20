import { FirebaseMessaging } from '../../core/firebase/firebase_messaging';
import { GameProvider } from '../../providers/game_provider';
import { UserProvider } from '../../providers/user_provider';
import { RoomEntity, Room } from '../../models/domain/room';
import { UserEntity } from '../../models/domain/user/user';
import { checkIds } from '../../core/validation/type_checks';
import { Strings } from '../../resources/strings';
import { TimerProvider } from '../../providers/timer_provider';
import { GameTemplateEntity } from '../../game_templates/models/game_template';
import { DomainErrors } from '../../core/exceptions/domain/domain_errors';
import { getCurrentEnvironment, rollbar } from '../../config';

export class RoomService {
  constructor(
    private gameProvider: GameProvider,
    private userProvider: UserProvider,
    private timerProvider: TimerProvider,
    private firebaseMessaging: FirebaseMessaging
  ) {}

  async createRoom(
    gameTemplateId: GameTemplateEntity.Id,
    currentUserId: UserEntity.Id
  ): Promise<Room> {
    return this.executeWithErrorReporting({ gameTemplateId, currentUserId }, async () => {
      const room = await this.gameProvider.createRoom(gameTemplateId, currentUserId);
      return room;
    });
  }

  /// Owner of the created room can add participants that will receive invite by push notification
  async addParticipantToRoom(participantId: UserEntity.Id, roomId: RoomEntity.Id) {
    return this.executeWithErrorReporting({ roomId, participantId }, async () => {
      const room = await this.gameProvider.getRoom(roomId);

      const participantIndex = room.participants.findIndex((p) => p.id === participantId);
      const isParticipantAlreadyAdded = participantIndex >= 0;

      if (isParticipantAlreadyAdded) {
        return;
      }

      const participantDevice = await this.userProvider.getUserDevice(participantId);

      const newRoomParticipant: RoomEntity.Participant = {
        id: participantId,
        status: 'waiting',
        deviceToken: participantDevice.token,
      };

      room.participants.push(newRoomParticipant);
      await this.gameProvider.updateRoom(room);

      this.firebaseMessaging
        .sendMulticastNotification({
          title: Strings.battleInvitationNotificationTitle(),
          body: room.owner.userName + ' ' + Strings.battleInvitationNotificationBody(),
          data: {
            roomId: room.id,
            type: 'go_to_room',
          },
          pushTokens: [participantDevice.token],
        })
        .catch((e) => {
          // TODO(Maxim): Process failed invites
          console.error('Failed sending room participant invite: ' + e);
        });
    });
  }

  /// Join to Game by setting status to 'ready'
  async onParticipantReady(roomId: RoomEntity.Id, participantId: UserEntity.Id) {
    return this.executeWithErrorReporting({ roomId, participantId }, async () => {
      checkIds([roomId, participantId]);

      const room = await this.gameProvider.getRoom(roomId);
      const participantIndex = room.participants.findIndex((p) => p.id === participantId);
      const isParticipantAlreadyAdded = participantIndex >= 0;

      if (isParticipantAlreadyAdded) {
        await this.gameProvider.setParticipantReady(roomId, participantId);
        return;
      }

      if (room.participants.length >= 6) {
        throw DomainErrors.participantsLimit;
      }

      const participantDevice = await this.userProvider.getUserDevice(participantId);

      const newRoomParticipant: RoomEntity.Participant = {
        id: participantId,
        status: 'ready',
        deviceToken: participantDevice.token,
      };

      room.participants.push(newRoomParticipant);
      await this.gameProvider.updateRoom(room);
    });
  }

  async createRoomGame(roomId: RoomEntity.Id) {
    return this.executeWithErrorReporting({ roomId }, async () => {
      const [room, game] = await this.gameProvider.createRoomGame(roomId);

      if (room.participants.length < 2) {
        throw new Error('ERROR: Multiplayer game cannot have lower than 2 participants');
      }

      this.timerProvider.scheduleTimer({
        startDateInUTC: game.state.moveStartDateInUTC,
        gameId: game.id,
        monthNumber: 1,
      });

      return { room, game };
    });
  }

  private async executeWithErrorReporting<T>(context: any, callback: () => Promise<T>): Promise<T> {
    const component = 'Room Service';
    const environment = getCurrentEnvironment();

    try {
      return await callback();
    } catch (err) {
      const errorMessage =
        'ROOM SERVICE\n' +
        `ENVIRONMENT: ${environment}\n` +
        `ERROR MESSAGE: ${err && err['message']}\n` +
        `CONTEXT: ${JSON.stringify(context, null, 2)}`;

      const error = new Error(errorMessage);
      rollbar.error(error, `COMPONENT: ${component}, ` + `ENVIRONMENT: ${environment}`);
      throw error;
    }
  }
}
