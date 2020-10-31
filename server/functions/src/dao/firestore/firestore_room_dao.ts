import * as uuid from 'uuid';
import { IRoomDAO } from '../room_dao';
import { FirestoreSelector } from '../../providers/firestore_selector';
import { Firestore } from '../../core/firebase/firestore';
import { User } from '../../models/domain/user/user';
import { Room, RoomEntity } from '../../models/domain/room';
import { GameTemplateEntity } from '../../game_templates/models/game_template';

export class FirestoreRoomDAO implements IRoomDAO {
  constructor(private selector: FirestoreSelector, private firestore: Firestore) {}

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
    RoomEntity.validate(room);

    const selector = this.selector.room(room.id);
    const updatedRoom = await this.firestore.updateItem(selector, room);

    RoomEntity.validate(updatedRoom);
    return updatedRoom as Room;
  }

  async createRoom(gameTemplateId: GameTemplateEntity.Id, owner: User): Promise<Room> {
    const ownerParticipant: RoomEntity.Participant = {
      id: owner.userId,
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
}
