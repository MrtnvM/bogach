import { EventFactory } from '../../../factory/event_factory';

export namespace HookahManEventFactory {
  export namespace Income {
    export const workBonus = (value: number) =>
      EventFactory.incomeEvent({
        name: 'Премия',
        description:
          'Сегодня было гостей было больше чем обычно. Небольшой процент с продаж - ваш!',
        value: [value, value, 0],
      });

    export const tip = (value: number) =>
      EventFactory.incomeEvent({
        name: 'Чаевые',
        description: 'Гости оставили Вам чаевые',
        value: [value, value, 0],
      });
  }

  export namespace Expense {
    export const fine1 = (value: number) =>
      EventFactory.expenseEvent({
        name: 'Штраф',
        description: 'Разбил колбу от кальяна',
        insuranceType: null,
        value: [value, value, 0],
      });

    export const fine2 = (value: number) =>
      EventFactory.expenseEvent({
        name: 'Штраф',
        description: 'Потерял чашу от кальяна',
        insuranceType: null,
        value: [value, value, 0],
      });

    export const fine3 = (value: number) =>
      EventFactory.expenseEvent({
        name: 'Штраф',
        description: 'Клиент ушел не заплатив',
        insuranceType: null,
        value: [value, value, 0],
      });

    export const canceledWorkBonus = (value: number) =>
      EventFactory.expenseEvent({
        name: 'Лишение премии',
        description: 'Уронил уголь на клиента',
        insuranceType: null,
        value: [value, value, 0],
      });

    export const unexpectedRestDay = (value: number) =>
      EventFactory.expenseEvent({
        name: 'Внеплановый выходной',
        description: 'Отключили свет, день без работы',
        insuranceType: null,
        value: [value, value, 0],
      });
  }
}
