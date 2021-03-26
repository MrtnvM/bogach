import { Asset } from '../asset';
import { Income } from '../income';
import { Strings } from '../../../resources/strings';
import { Entity } from '../../../core/domain/entity';

export interface RealtyAsset extends Asset {
  readonly buyPrice: number;
  readonly downPayment: number;
  readonly fairPrice: number;
  readonly passiveIncomePerMonth: number;
  readonly payback: number;
  readonly sellProbability: number;
}

export namespace RealtyAssetEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<RealtyAsset>(asset, 'Realty Asset');

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

  export const getIncomeValue = (asset: RealtyAsset) => {
    return asset.passiveIncomePerMonth;
  };

  export const getIncome = (asset: RealtyAsset): Income => {
    validate(asset);

    return {
      id: asset.id ?? null,
      name: Strings.realty(),
      value: getIncomeValue(asset),
      type: 'realty',
    };
  };
}
