import { InsuranceEvent } from './insurance_event';
import { ValueRange } from '../../core/data/value_range';

export namespace InsuranceGeneratorConfig {
  export const healthInsurance = (event?: Partial<InsuranceEvent.Info>) => {
    const cost: ValueRange = event?.cost ?? { min: 2000, max: 5000, stepValue: 500 };

    const value: ValueRange = event?.value ?? {
      min: cost.min + 3000,
      max: cost.max + 5000,
      stepValue: cost.stepValue,
    };

    const insuranceInfo: InsuranceEvent.Info = {
      name: event?.name ?? 'Страхование жизни',
      description:
        event?.description ??
        'Страховая компания предлагает купить полис ' +
          'и защитить свое здоровье от непредвиденных ситуаций',
      insuranceType: 'health',
      cost,
      value,
      duration: event?.duration ?? 12,
    };

    return insuranceInfo;
  };

  export const propertyInsurance = (event?: Partial<InsuranceEvent.Info>) => {
    const cost: ValueRange = event?.cost ?? { min: 2000, max: 5000, stepValue: 500 };

    const value: ValueRange = event?.value ?? {
      min: cost.min + 3000,
      max: cost.max + 5000,
      stepValue: cost.stepValue,
    };

    const insuranceInfo: InsuranceEvent.Info = {
      name: event?.name ?? 'Страхование имущества',
      description:
        event?.description ??
        'Страховая компания предлагает купить полис ' +
          'и защитить свое имущество от непредвиденных ситуаций',
      insuranceType: 'property',
      cost,
      value,
      duration: event?.duration ?? 12,
    };

    return insuranceInfo;
  };
}
