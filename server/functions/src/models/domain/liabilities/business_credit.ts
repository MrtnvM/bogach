import { Liability } from '../liability';
import { Entity } from '../../../core/domain/entity';

export interface BusinessCreditLiability extends Liability {
  readonly value: number;
}

export namespace BusinessCreditLiabilityEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<BusinessCreditLiability>(
      asset,
      'Business Credit Liability'
    );

    entity.hasNumberValue('value');

    entity.checkWithRules([[(a) => a.value <= 0, "Value can't be <= 0"]]);
  };
}
