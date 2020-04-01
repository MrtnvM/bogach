import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface BusinessAsset extends Asset {
  readonly downPayment: number;
  readonly cost: number;
}

export namespace BusinessAssetEntity {
  export const parse = (asset: Asset, data: any): BusinessAsset => {
    const { downPayment, cost } = data;

    return { ...asset, downPayment, cost };
  };

  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<BusinessAsset>(asset, 'Business Asset');

    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('cost');

    entity.checkWithRules([
      [a => a.downPayment <= 0, "Down payment can't be <= 0"],
      [a => a.cost <= 0, "Cost can't be <= 0"]
    ]);
  };
}
