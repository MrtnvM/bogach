import { Liability } from '../liability';
import { Entity } from '../../../core/domain/entity';

export interface OtherLiability extends Liability {
  readonly value: number;
}

export namespace OtherLiabilityEntity {
  export const validate = (asset: any) => {
    const entity = Entity.createEntityValidator<OtherLiability>(asset, 'Other Liability');

    entity.hasNumberValue('value');

    entity.checkWithRules([[(a) => a.value <= 0, "Value can't be <= 0"]]);
  };
}
