import { GameTemplateEntity } from '../game_templates/models/game_template';
import { Room, RoomEntity } from '../models/domain/room';
import { User } from '../models/domain/user';

export interface IRoomDAO {
  createRoom(gameTemplateId: GameTemplateEntity.Id, owner: User): Promise<Room>;
  updateRoom(room: Room): Promise<Room>;

  getRoom(roomId: RoomEntity.Id): Promise<Room>;
}
