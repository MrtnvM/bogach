import { ValueRange } from '../core/data/value_range';

import { IncomeEvent } from '../events/income/income_event';
import { IncomeEventGenerator } from '../events/income/income_event_generator';

import { ExpenseEvent } from '../events/expense/expense_event';
import { ExpenseEventGenerator } from '../events/expense/expense_event_generator';

import { InsuranceEvent } from '../events/insurance/insurance_event';
import { InsuranceAssetEntity } from '../models/domain/assets/insurance_asset';
import { InsuranceEventGenerator } from '../events/insurance/insurance_event_generator';
import { InsuranceGeneratorConfig } from '../events/insurance/insurance_generator_config';

import { DebentureEvent } from '../events/debenture/debenture_event';
import { DebentureEventGenerator } from '../events/debenture/debenture_event_generator';

const valueRange = (values: [number, number, number]): ValueRange => {
  return {
    min: values[0],
    max: values[1],
    stepValue: values[2],
  };
};

const optioanlValueRange = (values?: [number, number, number]): ValueRange | undefined => {
  return values && valueRange(values);
};

export namespace EventFactory {
  export const incomeEvent = (props: {
    name: string;
    description: string;
    value: [number, number, number];
  }): IncomeEvent.Event => {
    const { name, description, value } = props;

    return IncomeEventGenerator.generateEvent({
      name,
      description,
      range: valueRange(value),
    });
  };

  export const expenseEvent = (props: {
    name: string;
    description: string;
    insuranceType: InsuranceAssetEntity.InsuranceType | null;
    value: [number, number, number];
  }): ExpenseEvent.Event => {
    const { name, description, value, insuranceType } = props;

    return ExpenseEventGenerator.generateEvent({
      name,
      description,
      insuranceType,
      range: valueRange(value),
    });
  };

  export const insuranceEvent = (props: {
    insuranceType: InsuranceAssetEntity.InsuranceType;
    name?: string;
    description?: string;
    cost?: [number, number, number];
    value?: [number, number, number];
    duration?: number;
  }): InsuranceEvent.Event => {
    const { insuranceType, name, description, cost, value, duration } = props;

    const eventInfo: Partial<InsuranceEvent.Info> = {
      name,
      description,
      cost: optioanlValueRange(cost),
      value: optioanlValueRange(value),
      duration,
      insuranceType,
    };

    switch (insuranceType) {
      case 'health':
        return InsuranceEventGenerator.generateEvent(
          InsuranceGeneratorConfig.healthInsurance(eventInfo)
        );

      case 'property':
        return InsuranceEventGenerator.generateEvent(
          InsuranceGeneratorConfig.propertyInsurance(eventInfo)
        );

      default:
        throw new Error('Unknown insurance type');
    }
  };

  export const debentureEvent = (props: {
    name: string;
    price: [number, number, number];
    nominal: [number, number, number];
    profitability: [number, number, number];
    availableCount?: [number, number, number];
  }): DebentureEvent.Event => {
    const { name, nominal, profitability, price, availableCount } = props;

    return DebentureEventGenerator.generateEvent({
      name,
      nominal: valueRange(nominal),
      profitability: valueRange(profitability),
      price: valueRange(price),
      availableCount: optioanlValueRange(availableCount),
    });
  };
}
