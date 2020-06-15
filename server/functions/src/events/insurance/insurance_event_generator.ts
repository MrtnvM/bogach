import { InsuranceEvent } from './insurance_event';
import uuid = require('uuid');
import * as random from 'random';
import { InsuranceAssetEntity } from '../../models/domain/assets/insurance_asset';

export namespace InsuranceEventGenerator {
  export const generate = (): InsuranceEvent.Event => {
    const id = uuid.v4();

    const insuranceType = generateInsuranceType();
    const insuranceDescription = getInsuranceDescription(insuranceType);
    const duration = 12;
    const value = random.int(800, 6000);
    const cost = random.int(300, 3000);

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
