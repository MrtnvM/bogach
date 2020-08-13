import { ValueRange } from '../core/data/value_range';
import { IncomeEventGenerator } from '../events/income/income_event_generator';
import { ExpenseEventGenerator } from '../events/expense/expense_event_generator';
import { InsuranceEvent } from '../events/insurance/insurance_event';
import { InsuranceAssetEntity } from '../models/domain/assets/insurance_asset';
import { InsuranceEventGenerator } from '../events/insurance/insurance_event_generator';
import { InsuranceGeneratorConfig } from '../events/insurance/insurance_generator_config';
import { DebentureEventGenerator } from '../events/debenture/debenture_event_generator';
import { StockEventGenerator } from '../events/stock/stock_event_generator';
import { MonthlyExpenseEventGenerator } from '../events/monthly_expense/monthly_expense_event_generator';
import { BusinessSellEventGenerator } from '../events/business/sell/business_sell_event_generator';
import { BusinessBuyEventGenerator } from '../events/business/buy/business_buy_event_generator';
import { SalaryChangeEventGenerator } from '../events/salary_change/salary_change_event_generator';

export namespace EventFactory {
  export const incomeEvent = IncomeEventGenerator.generateEvent;

  export const expenseEvent = ExpenseEventGenerator.generateEvent;
  export const monthlyExpenseEvent = MonthlyExpenseEventGenerator.generateEvent;

  export const salaryChangeEvent = SalaryChangeEventGenerator.generateEvent;

  export const debentureEvent = DebentureEventGenerator.generateEvent;
  export const stockEvent = StockEventGenerator.generateEvent;

  export const buyBussinessEvent = BusinessBuyEventGenerator.generateEvent;
  export const sellBusinessEvent = BusinessSellEventGenerator.generateEvent;

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
}
