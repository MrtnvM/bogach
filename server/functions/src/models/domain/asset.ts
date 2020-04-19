import { Entity } from '../../core/domain/entity';
import { DebentureAssetEntity, DebentureAsset } from './assets/debenture_asset';
import { InsuranceAsset } from './assets/insurance_asset';
import { StockAsset } from './assets/stock_asset';
import { RealtyAsset } from './assets/realty_asset';
import { BusinessAsset } from './assets/business_asset';
import { CashAsset } from './assets/cash_asset';
import { OtherAsset } from './assets/other_asset';

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
    | 'stock'
    | 'realty'
    | 'business'
    | 'cash'
    | 'other';

  export const TypeValues: Type[] = [
    'insurance',
    'debenture',
    'stock',
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

  const filterAssets = <T extends Asset>(assets: Asset[], type: Type) => {
    return (assets?.filter(a => a.type === type) as T[]) ?? [];
  };

  export const getInsurances = (assets: Asset[]) => {
    return filterAssets<InsuranceAsset>(assets, 'insurance');
  };

  export const getDebentures = (assets: Asset[]) => {
    return filterAssets<DebentureAsset>(assets, 'debenture');
  };

  export const getStocks = (assets: Asset[]) => {
    return filterAssets<StockAsset>(assets, 'stock');
  };

  export const getRealties = (assets: Asset[]) => {
    return filterAssets<RealtyAsset>(assets, 'realty');
  };

  export const getBusinesses = (assets: Asset[]) => {
    return filterAssets<BusinessAsset>(assets, 'business');
  };

  export const getCash = (assets: Asset[]) => {
    return filterAssets<CashAsset>(assets, 'cash');
  };

  export const getOthers = (assets: Asset[]) => {
    return filterAssets<OtherAsset>(assets, 'other');
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
