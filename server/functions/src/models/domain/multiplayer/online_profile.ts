import { Entity } from '../../../core/domain/entity';

export interface OnlineProfile {
  readonly userId: string;
  readonly fullName: string;
  readonly avatarUrl: string;
  readonly onlineAt: number;
}

export namespace OnlineProfileEntity {
  export const validate = (purchase: any) => {
    const entity = Entity.createEntityValidator<OnlineProfile>(purchase, 'OnlineProfile');

    entity.hasStringValue('userId');
    entity.hasStringValue('fullName');
    entity.hasStringValue('avatarUrl');
    entity.hasNumberValue('onlineAt');
  };
}
