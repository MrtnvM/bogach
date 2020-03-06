import { Entity } from '../../core/domain/entity';
import { DebentureAssetEntity, DebentureAsset } from './assets/debenture_asset';

export interface Asset {
  readonly id?: AssetEntity.Id;
  readonly name: string;
  readonly type: AssetEntity.Type;
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}

export namespace AssetEntity {
  export type Id = string;

  export type Type = 'insurance' | 'debeture' | 'stocks' | 'realty' | 'business' | 'other';
  export const TypeValues: Type[] = [
    'insurance',
    'debeture',
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

    const assetType: Type = asset.type;

    switch (assetType) {
      case 'debeture':
        DebentureAssetEntity.validate(asset);
        break;
    }
  };

  export const getIncome = (asset: Asset) => {
    if (asset.type === 'debeture') {
      return DebentureAssetEntity.getIncome(asset as DebentureAsset);
    }

    return undefined;
  };

  export const getExpense = (asset: Asset) => {
    return undefined;
  };
}
