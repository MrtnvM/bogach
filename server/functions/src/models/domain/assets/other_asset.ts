import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface OtherAsset extends Asset {
  readonly downPayment: number;
  readonly value: number;
}

export namespace OtherAssetEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<OtherAsset>(asset, 'Other Asset');

    entity.hasNumberValue('downPayment');
    entity.hasNumberValue('value');

    entity.checkWithRules([
      [(a) => a.downPayment <= 0, "Down payment can't be <= 0"],
      [(a) => a.value <= 0, "Value can't be <= 0"],
    ]);
  };
}
