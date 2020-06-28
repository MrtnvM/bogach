import { Asset } from '../asset';
import { Income } from '../income';
import { Strings } from '../../../resources/strings';
import { Entity } from '../../../core/domain/entity';

export interface RealtyAsset extends Asset {
  readonly downPayment: number;
  readonly cost: number;
  readonly passiveIncomePerMonth: number;
}

export namespace RealtyAssetEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<RealtyAsset>(asset, 'Debenture Asset');

    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('cost');
    entity.hasNumberValue('passiveIncomePerMonth');

    entity.checkWithRules([
      [(a) => a.downPayment <= 0, "Down payment can't be <= 0"],
      [(a) => a.cost <= 0, "Cost can't be <= 0"],
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
