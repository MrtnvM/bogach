export interface User {
  readonly id: UserEntity.Id;
  readonly userName: string;
  readonly currentQuestIndex?: number;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export interface UserDevice {
  platform: 'ios' | 'android';
  token: string;
}

export namespace UserEntity {
  export type Id = string;
}
