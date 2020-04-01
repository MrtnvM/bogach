import { Asset } from '../asset';
import { Income } from '../income';
import { Strings } from '../../../resources/strings';
import { Entity } from '../../../core/domain/entity';

export interface RealtyAsset extends Asset {
  readonly downPayment: number;
  readonly cost: number;
}

export namespace RealtyAssetEntity {
  export const parse = (asset: Asset, data: any): RealtyAsset => {
    const { downPayment, cost } = data;

    return { ...asset, downPayment, cost };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<RealtyAsset>(asset, 'Debenture Asset');

    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('cost');

    entity.checkWithRules([
      [a => a.downPayment <= 0, "Down payment can't be <= 0"],
      [a => a.cost <= 0, "Cost can't be <= 0"]
    ]);
  };

  export const getIncome = (asset: RealtyAsset): Income => {
    validate(asset);

    const incomeValue = (asset.cost * 1) / 100;

    return {
      name: Strings.realty(),
      value: incomeValue,
      type: 'realty'
    };
  };
}
