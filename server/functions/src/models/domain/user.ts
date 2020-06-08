export interface User {
  readonly id: UserEntity.Id;
  readonly userName: string;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace UserEntity {
  export type Id = string;
}
