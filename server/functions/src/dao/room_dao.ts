import { GameTemplateEntity } from '../game_templates/models/game_template';
import { Room, RoomEntity } from '../models/domain/room';
import { User } from '../models/domain/user/user';

export interface IRoomDAO {
  getRoom(roomId: RoomEntity.Id): Promise<Room>;
  createRoom(gameTemplateId: GameTemplateEntity.Id, owner: User): Promise<Room>;
  updateRoom(room: Room): Promise<Room>;
}
