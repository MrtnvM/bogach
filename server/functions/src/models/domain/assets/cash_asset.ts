import { Asset } from '../asset';
import { Entity } from '../../../core/domain/entity';

export interface CashAsset extends Asset {
  readonly value: number;
}

export namespace InsuranceAssetEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<CashAsset>(asset, 'Cash Asset');

    entity.hasNumberValue('value');

    entity.checkWithRules([[(a) => a.value <= 0, "Value can't be <= 0"]]);
  };
}
