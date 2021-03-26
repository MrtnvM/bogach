import { ValueRange } from '../../core/data/value_range';

export namespace IncomeGeneratorConfig {
  export type IncomeEventInfo = {
    readonly name: string;
    readonly description: string;
    readonly range: ValueRange;
  };

  export const allIncomes: IncomeEventInfo[] = [
    {
      name: 'Наследство',
      description: 'Вы получили наследство от дальнего родственника',
      range: { min: 10_000, max: 30_000, stepValue: 5_000 },
    },
    {
      name: 'Продажа',
      description: 'Вы продали неиспользуемый письменный стол на Авито',
      range: { min: 4_000, max: 8_000, stepValue: 500 },
    },
    {
      name: 'Премия',
      description: 'Вы получили премию на работе',
      range: { min: 3_000, max: 10_000, stepValue: 1_000 },
    },
    {
      name: 'Налоговый вычет',
      description: 'Вы получили налоговый вычет',
      range: { min: 10_000, max: 20_000, stepValue: 1_000 },
    },
    {
      name: 'Программа государственной поддержки',
      description: 'Вы получили единоразовую социальную выплату',
      range: { min: 5_000, max: 12_000, stepValue: 1_000 },
    },
  ];
}
