import { Asset } from '../asset';
import { Income } from '../income';
import { Strings } from '../../../resources/strings';
import { Entity } from '../../../core/domain/entity';

export interface DebentureAsset extends Asset {
  readonly currentPrice: number;
  readonly nominal: number;
  readonly profitabilityPercent: number;
  readonly count: number;
}

export namespace DebentureAssetEntity {
  export const parse = (asset: Asset, data: any): DebentureAsset => {
    const { currentPrice, nominal, profitabilityPercent, count } = data;

    return {
      ...asset,
      currentPrice,
      nominal,
      profitabilityPercent,
      count
    };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<DebentureAsset>(asset, 'Debenture Asset');

    entity.hasNumberValue('currentPrice');
    entity.hasNumberValue('nominal');
    entity.hasNumberValue('profitabilityPercent');
    entity.hasNumberValue('count');

    entity.checkWithRules([
      [a => a.count <= 0, "Count can't be <= 0"],
      [a => a.nominal <= 0, "Nominal can't be <= 0"],
      [a => a.profitabilityPercent < 0, "Profitability percent can't be < 0"],
      [a => a.currentPrice <= 0, "Current price percent can't be <= 0"]
    ]);
  };

  export const getIncome = (asset: DebentureAsset): Income => {
    validate(asset);

    const incomeValue = (asset.nominal * asset.profitabilityPercent) / 100;

    return {
      name: Strings.debetures(),
      value: incomeValue,
      type: 'investment'
    };
  };
}
