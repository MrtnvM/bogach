import { Entity } from '../../core/domain/entity';
import { DebentureAssetEntity, DebentureAsset } from './assets/debenture_asset';

export interface Asset {
  readonly id?: AssetEntity.Id;
  readonly name: string;
  readonly type: AssetEntity.Type;
}

export namespace AssetEntity {
  export type Id = string;

  export type Type =
    | 'insurance'
    | 'debenture'
    | 'stocks'
    | 'realty'
    | 'business'
    | 'cash'
    | 'other';

  export const TypeValues: Type[] = [
    'insurance',
    'debenture',
    'stocks',
    'realty',
    'business',
    'cash',
    'other'
  ];

  export const parse = (data: any): Asset => {
    const { id, name, type } = data;
    let asset: Asset = { id, name, type };

    const assetType: Type = asset.type;
    asset = Entity.parse<Type>(asset, data, assetType, [['debenture', DebentureAssetEntity.parse]]);

    validate(asset);

    return asset;
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<Asset>(asset, 'Asset');

    entity.hasValue('name');
    entity.hasValue('type');
    entity.checkUnion('type', TypeValues);

    const assetType: Type = asset.type;

    Entity.validate<Type>(asset, assetType, [['debenture', DebentureAssetEntity.validate]]);
  };

  export const getIncome = (asset: Asset) => {
    if (asset.type === 'debenture') {
      return DebentureAssetEntity.getIncome(asset as DebentureAsset);
    }

    // TODO: Implement incomes from other asset types

    return undefined;
  };

  export const getExpense = (asset: Asset) => {
    return undefined;
  };
}
