import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';
import { Strings } from '../../../resources/strings';
import { Income } from '../income';

export interface BusinessAsset extends Asset {
  readonly buyPrice: number;
  readonly downPayment: number;
  readonly fairPrice: number;
  readonly passiveIncomePerMonth: number;
  readonly payback: number;
  readonly sellProbability: number;
}

export namespace BusinessAssetEntity {
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

  export const getIncomeValue = (asset: BusinessAsset) => {
    return asset.passiveIncomePerMonth;
  };

  export const getIncome = (asset: BusinessAsset): Income => {
    return {
      id: asset.id || null,
      name: Strings.business(),
      value: getIncomeValue(asset),
      type: 'business',
    };
  };
}
