import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface InsuranceAsset extends Asset {
  readonly downPayment: number;
  readonly value: number;
}

export namespace InsuranceAssetEntity {
  export const parse = (asset: Asset, data: any): InsuranceAsset => {
    const { downPayment, value } = data;

    return { ...asset, downPayment, value };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<InsuranceAsset>(asset, 'Insurance Asset');

    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('value');

    entity.checkWithRules([
      [a => a.downPayment <= 0, "Down payment can't be <= 0"],
      [a => a.value <= 0, "Insurance value can't be <= 0"]
    ]);
  };
}
