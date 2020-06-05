import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface BusinessAsset extends Asset {
  readonly buyPrice: number;
  readonly downPayment: number;
  readonly fairPrice: number;
  readonly passiveIncomePerMonth: number;
  readonly payback: number;
  readonly sellProbability: number;
}

export namespace BusinessAssetEntity {
  export const parse = (asset: Asset, data: any): BusinessAsset => {
    const {
      buyPrice,
      downPayment,
      fairPrice,
      passiveIncomePerMonth,
      payback,
      sellProbability,
    } = data;

    return {
      ...asset,
      buyPrice,
      downPayment,
      fairPrice,
      passiveIncomePerMonth,
      payback,
      sellProbability,
    };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<BusinessAsset>(asset, 'Business Asset');

    entity.hasNumberValue('buyPrice');
    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('fairPrice');
    entity.hasNumberValue('passiveIncomePerMonth');
    entity.hasNumberValue('payback');
    entity.hasNumberValue('sellProbability');

    entity.checkWithRules([
      [(a) => a.buyPrice <= 0, "BuyPrice can't be <= 0"],
      [(a) => a.downPayment <= 0, "DownPayment can't be <= 0"],
      [(a) => a.fairPrice <= 0, "FairPrice can't be <= 0"],
      [(a) => a.sellProbability <= 0, "SellProbability can't be <= 0"],
    ]);
  };
}
