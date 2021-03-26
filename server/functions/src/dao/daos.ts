import { IGameDAO } from './game_dao';
import { IUserDAO } from './user_dao';
import { IRoomDAO } from './room_dao';

export type DAOs = {
  readonly game: IGameDAO;
  readonly user: IUserDAO;
  readonly room: IRoomDAO;
};
