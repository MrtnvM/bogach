import { UserEntity } from '../user/user';

export type ParticipantGameState<T> = {
  [userId: string]: T;
};

export const createParticipantsGameState = <T>(userIds: UserEntity.Id[], initialValue: T) => {
  const state: ParticipantGameState<T> = {};

  userIds.forEach((userId) => {
    state[userId] = initialValue;
  });

  return state;
};
