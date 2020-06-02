import { Entity } from '../../core/domain/entity';
import { UserEntity } from './user';
import { GameTemplateEntity } from './game/game_template';
import { GameEntity } from './game/game';

export interface Room {
  id: RoomEntity.Id;
  gameTemplateId: GameTemplateEntity.Id;
  participants: RoomEntity.Participant[];
  gameId?: GameEntity.Id;
}

export namespace RoomEntity {
  export type Id = string;

  export type ParticipantStatus = 'ready' | 'waiting';
  const ParticipantStatusValues = ['ready', 'waiting'];

  export type Participant = {
    id: UserEntity.Id;
    status: ParticipantStatus;
  };

  export const parse = (data: any): Room => {
    const { id, gameTemplateId, participants, gameId } = data;
    const room: Room = { id, gameTemplateId, participants, gameId };

    validate(room);
    return room;
  };

  export const validate = (room: any) => {
    const entity = Entity.createEntityValidator<Room>(room, 'Room');

    entity.hasValue('id');
    entity.hasValue('gameTemplateId');
    entity.hasValue('participants');

    const roomEntity = room as Room;
    roomEntity.participants.forEach(validateParticipant);
  };

  const validateParticipant = (participant: any) => {
    const entity = Entity.createEntityValidator<Participant>(participant, 'Room Participant');

    entity.hasValue('id');
    entity.hasValue('status');
    entity.checkUnion('status', ParticipantStatusValues);
  };
}
