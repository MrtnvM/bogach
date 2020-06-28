import { Liability } from '../liability';
import { Entity } from '../../../core/domain/entity';

export interface MortgageLiability extends Liability {
  readonly value: number;
}

export namespace MortgageLiabilityEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<MortgageLiability>(asset, 'Mortgage Liability');

    entity.hasNumberValue('value');

    entity.checkWithRules([[(a) => a.value <= 0, "Value can't be <= 0"]]);
  };
}
