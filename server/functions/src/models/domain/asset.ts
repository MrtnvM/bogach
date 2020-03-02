import { Entity } from '../../core/domain/entity';

export interface Asset {
  readonly id?: AssetEntity.Id;
  readonly name: string;
  readonly type: AssetEntity.Type;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace AssetEntity {
  export type Id = string;

  export type Type = 'insurance' | 'investment' | 'stocks' | 'realty' | 'business' | 'other';
  export const TypeValues: Type[] = [
    'insurance',
    'investment',
    'stocks',
    'realty',
    'business',
    'other'
  ];

  export const parse = (data: any): Asset => {
    const { id, name, type } = data;
    const asset = { id, name, type };

    validate(asset);

    return asset;
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<Asset>(asset);

    entity.hasValue('name');
    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);
  };
}
