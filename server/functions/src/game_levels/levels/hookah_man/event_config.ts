import { EventConfig } from '../../models/event_config';

export const eventConfig: EventConfig = {
  incomeEvents: [
    {
      name: 'Премия',
      description: 'Сегодня было гостей было больше чем обычно. Небольшой процент с продаж - ваш!',
      range: { min: 1_000, max: 4_000, stepValue: 500 },
    },
    {
      name: 'Чаевые',
      description: 'Гости оставили Вам чаевые',
      range: { min: 1_000, max: 3_000, stepValue: 100 },
    },
  ],
  expenseEvents: [
    {
      name: 'Штраф',
      description: 'Разбил колбу от кальяна',
      range: { min: 1_000, max: 3_000, stepValue: 200 },
      insuranceType: null,
    },
    {
      name: 'Штраф',
      description: 'Потерял чашу от кальяна',
      range: { min: 1_000, max: 3_000, stepValue: 200 },
      insuranceType: null,
    },
    {
      name: 'Лишение премии',
      description: 'Уронил уголь на клиента',
      range: { min: 2_000, max: 5_000, stepValue: 500 },
      insuranceType: null,
    },
    {
      name: 'Штраф',
      description: 'Клиент ушел не заплатив',
      range: { min: 6_00, max: 2_000, stepValue: 100 },
      insuranceType: null,
    },
    {
      name: 'Внеплановый выходной',
      description: 'Отключили свет, день без работы',
      range: { min: 2_000, max: 4_000, stepValue: 100 },
      insuranceType: null,
    },
  ],
  debentureEvents: [],
};
