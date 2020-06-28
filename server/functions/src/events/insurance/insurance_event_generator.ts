import { InsuranceEvent } from './insurance_event';
import uuid = require('uuid');
import * as random from 'random';
import { InsuranceAssetEntity } from '../../models/domain/assets/insurance_asset';
import { randomValueFromRange } from '../../core/data/value_range';

export namespace InsuranceEventGenerator {
  export const generate = (): InsuranceEvent.Event => {
    const id = uuid.v4();

    const insuranceType = generateInsuranceType();
    const insuranceDescription = getInsuranceDescription(insuranceType);
    const duration = 12;

    const cost = randomValueFromRange({
      min: 2000,
      max: 5000,
      stepValue: 1000,
    });

    const value = randomValueFromRange({
      min: cost + 2000,
      max: cost + 10000,
      stepValue: 1000,
    });

    return {
      id,
      name: 'Страховка',
      description: insuranceDescription,
      type: InsuranceEvent.Type,
      data: {
        insuranceType,
        duration,
        value,
        cost,
      },
    };
  };

  const generateInsuranceType = (): InsuranceAssetEntity.InsuranceType => {
    const randomInt = random.int(0, 100);
    if (randomInt <= 50) {
      return 'health';
    } else {
      return 'property';
    }
  };

  const getInsuranceDescription = (type: InsuranceAssetEntity.InsuranceType): string => {
    if (type === 'health') {
      return (
        'Страховая компания предлагает купить полис и защитить свое здоровье' +
        ' от непредвиденных ситуаций. Действие полиса 1 год.'
      );
    } else if (type === 'property') {
      return (
        'Страховая компания предлагает купить полис и защитить свое имущество' +
        ' от непредвиденных ситуаций. Действие полиса 1 год.'
      );
    } else {
      throw Error('incorrect insuranceType: ' + type);
    }
  };
}
