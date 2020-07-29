import { IncomeEventGenerator } from '../events/income/income_event_generator';
import { IncomeEvent } from '../events/income/income_event';
import { ExpenseEvent } from '../events/expense/expense_event';
import { ExpenseEventGenerator } from '../events/expense/expense_event_generator';
import { InsuranceAssetEntity } from '../models/domain/assets/insurance_asset';

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
      range: { min: value[0], max: value[1], stepValue: value[2] },
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
      range: { min: value[0], max: value[1], stepValue: value[2] },
    });
  };
}
