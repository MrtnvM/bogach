import { Asset } from '../asset';
import { Income } from '../income';
import { Strings } from '../../../resources/strings';
import { Entity } from '../../../core/domain/entity';

export interface DebentureAsset extends Asset {
  readonly averagePrice: number;
  readonly nominal: number;
  readonly profitabilityPercent: number;
  readonly count: number;
}

export namespace DebentureAssetEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<DebentureAsset>(asset, 'Debenture Asset');

    entity.hasNumberValue('averagePrice');
    entity.hasNumberValue('nominal');
    entity.hasNumberValue('profitabilityPercent');
    entity.hasNumberValue('count');

    entity.checkWithRules([
      [(a) => a.count <= 0, "Count can't be <= 0"],
      [(a) => a.nominal <= 0, "Nominal can't be <= 0"],
      [(a) => a.profitabilityPercent < 0, "Profitability percent can't be < 0"],
      [(a) => a.averagePrice <= 0, "AveragePrice price percent can't be <= 0"],
    ]);
  };

  export const getIncomeValue = (asset: DebentureAsset) => {
    return (asset.nominal * asset.count * (asset.profitabilityPercent / 100)) / 12;
  };

  export const getIncome = (asset: DebentureAsset): Income => {
    validate(asset);

    return {
      id: asset.id || null,
      name: Strings.debetures(),
      value: getIncomeValue(asset),
      type: 'investment',
    };
  };
}
