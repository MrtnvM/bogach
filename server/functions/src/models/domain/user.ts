export type UserId = string;

export interface User {
  readonly id: UserId;
  readonly nickname: string;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}
