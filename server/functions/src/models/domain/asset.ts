import { Entity } from '../../core/domain/entity';
import { DebentureAssetEntity, DebentureAsset } from './assets/debenture_asset';
import { InsuranceAsset } from './assets/insurance_asset';
import { StockAsset, StockAssetEntity } from './assets/stock_asset';
import { RealtyAsset, RealtyAssetEntity } from './assets/realty_asset';
import { BusinessAsset, BusinessAssetEntity } from './assets/business_asset';
import { CashAsset } from './assets/cash_asset';
import { OtherAsset } from './assets/other_asset';
import { Income } from './income';

export interface Asset {
  readonly id?: AssetEntity.Id;
  readonly name: string;
  readonly type: AssetEntity.Type;
}

export namespace AssetEntity {
  export type Id = string;

  export type Type = 'insurance' | 'debenture' | 'stock' | 'realty' | 'business' | 'cash' | 'other';

  export const TypeValues: Type[] = [
    'insurance',
    'debenture',
    'stock',
    'realty',
    'business',
    'cash',
    'other',
  ];

  export const parse = (data: any): Asset => {
    const { id, name, type } = data;
    let asset: Asset = { id, name, type };

    const assetType: Type = asset.type;
    asset = Entity.parse<Type>(asset, data, assetType, [['debenture', DebentureAssetEntity.parse]]);

    // TODO add support for other types in another task

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
    return (assets?.filter((a) => a.type === type) as T[]) ?? [];
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

  export const getIncomeValue = (asset: Asset): number => {
    switch (asset.type) {
      case 'insurance':
        return 0;

      case 'debenture':
        const debenture = asset as DebentureAsset;
        return DebentureAssetEntity.getIncomeValue(debenture);

      case 'stock':
        const stock = asset as StockAsset;
        return StockAssetEntity.getIncomeValue(stock);

      case 'realty':
        const realty = asset as RealtyAsset;
        return RealtyAssetEntity.getIncomeValue(realty);

      case 'business':
        const business = asset as BusinessAsset;
        return BusinessAssetEntity.getIncomeValue(business);

      case 'cash':
        return 0;

      case 'other':
        return 0;

      default:
        throw new Error("ERROR: Can't determine income for asset with type: " + asset.type);
    }
  };

  export const getIncome = (asset: Asset): Income | undefined => {
    switch (asset.type) {
      case 'insurance':
        return undefined;

      case 'debenture':
        const debenture = asset as DebentureAsset;
        return DebentureAssetEntity.getIncome(debenture);

      case 'stock':
        const stock = asset as StockAsset;
        return StockAssetEntity.getIncome(stock);

      case 'realty':
        const realty = asset as RealtyAsset;
        return RealtyAssetEntity.getIncome(realty);

      case 'business':
        const business = asset as BusinessAsset;
        return BusinessAssetEntity.getIncome(business);

      case 'cash':
        return undefined;

      case 'other':
        return undefined;

      default:
        throw new Error("ERROR: Can't determine income for asset with type: " + asset.type);
    }
  };

  export const getExpense = (asset: Asset) => {
    return undefined;
  };

  export const getAssetValue = (asset: Asset): number => {
    switch (asset.type) {
      case 'insurance':
        const insurance = asset as InsuranceAsset;
        return insurance.value;

      case 'debenture':
        const debenture = asset as DebentureAsset;
        return debenture.averagePrice * debenture.count;

      case 'stock':
        const stock = asset as StockAsset;
        return stock.averagePrice * stock.countInPortfolio;

      case 'realty':
        const realty = asset as RealtyAsset;
        return realty.cost;

      case 'business':
        const business = asset as BusinessAsset;
        return business.buyPrice;

      case 'cash':
        const cash = asset as CashAsset;
        return cash.value;

      case 'other':
        const otherAsset = asset as OtherAsset;
        return otherAsset.value;

      default:
        throw new Error("ERROR: Can't determine value for asset with type: " + asset.type);
    }
  };
}
