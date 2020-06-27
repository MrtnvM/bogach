import { InsuranceAssetEntity } from '../../models/domain/assets/insurance_asset';
import { ValueRange } from '../../core/data/value_range';

export namespace ExpenseGeneratorConfig {
  type ExpenseEventInfo = {
    readonly name: string;
    readonly description: string;
    readonly insuranceType: InsuranceAssetEntity.InsuranceType | null;
    readonly range: ValueRange;
  };

  export const healthExpenses: ExpenseEventInfo[] = [
    {
      name: 'Проблемы со здоровьем',
      description: 'Вы посетили больницу',
      insuranceType: 'health',
      range: { min: 1000, max: 5000, stepValue: 500 },
    },
    {
      name: 'Визит к стоматологу',
      description: 'Вы посетили стоматологическую клинику',
      insuranceType: 'health',
      range: { min: 1000, max: 5000, stepValue: 500 },
    },
  ];

  export const propertyExpenses: ExpenseEventInfo[] = [
    {
      name: 'Проблемы с имуществом',
      description: 'Срочно нужны деньги на ремонт холодильника',
      insuranceType: 'property',
      range: { min: 1500, max: 6000, stepValue: 500 },
    },
    {
      name: 'Проблемы с имуществом',
      description: 'Срочно нужны деньги на ремонт комьютера',
      insuranceType: 'property',
      range: { min: 1000, max: 4000, stepValue: 500 },
    },
  ];

  export const otherExpenses: ExpenseEventInfo[] = [
    {
      name: 'Встреча с друзьями',
      description: 'Вы хорошо провели время в компании близких друзей',
      insuranceType: 'property',
      range: { min: 1000, max: 5000, stepValue: 500 },
    },
  ];

  export const allExpenses: ExpenseEventInfo[] = [
    ...healthExpenses,
    ...propertyExpenses,
    ...otherExpenses,
  ];
}
