export interface User {
  readonly userId: UserEntity.Id;
  readonly userName: string;
  readonly currentQuestIndex?: number;
  readonly boughtQuestsAccess?: boolean;
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
