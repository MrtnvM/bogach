import { optionalValueRange, ValueRange } from '../core/data/value_range';

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
import { StockEvent } from '../events/stock/stock_event';
import { StockEventGenerator } from '../events/stock/stock_event_generator';

import { MonthlyExpenseEvent } from '../events/monthly_expense/monthly_expense_event';
import { MonthlyExpenseEventGenerator } from '../events/monthly_expense/monthly_expense_event_generator';

export namespace EventFactory {
  export const incomeEvent = (props: IncomeEvent.Info) => {
    return IncomeEventGenerator.generateEvent(props);
  };

  export const expenseEvent = (props: ExpenseEvent.Info) => {
    return ExpenseEventGenerator.generateEvent(props);
  };

  export const insuranceEvent = (props: {
    insuranceType: InsuranceAssetEntity.InsuranceType;
    name?: string;
    description?: string;
    cost?: ValueRange;
    value?: ValueRange;
    duration?: number;
  }): InsuranceEvent.Event => {
    const { insuranceType, name, description, cost, value, duration } = props;

    const eventInfo: Partial<InsuranceEvent.Info> = {
      name,
      description,
      cost,
      value,
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

  export const debentureEvent = (props: DebentureEvent.Info) => {
    return DebentureEventGenerator.generateEvent(props);
  };

  export const stockEvent = (props: StockEvent.Info) => {
    return StockEventGenerator.generateEvent(props);
  };

  export const monthlyExpenseEvent = (props: MonthlyExpenseEvent.Info) => {
    return MonthlyExpenseEventGenerator.generateEvent(props);
  };
}
