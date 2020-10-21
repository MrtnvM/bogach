import { User, UserEntity } from '../models/domain/user';

export interface IUserDAO {
  getUser(userId: UserEntity.Id): Promise<User>;
}
