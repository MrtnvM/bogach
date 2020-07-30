import { EventFactory } from '../../../factory/event_factory';

namespace IncomeFactory {
  export const workBonus = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Премия',
      description: 'Сегодня было гостей было больше чем обычно. Небольшой процент с продаж - ваш!',
      value: [value, value, 0],
    });

  export const tip = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Чаевые',
      description: 'Гости оставили Вам чаевые',
      value: [value, value, 0],
    });
}

namespace ExpenseFactory {
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

namespace InsuraceFactory {
  export const healthInsurance = (cost: number, value: number) =>
    EventFactory.insuranceEvent({
      insuranceType: 'health',
      cost: [cost, cost, 0],
      value: [value, value, 0],
    });

  export const propertyInsurance = (cost: number, value: number) =>
    EventFactory.insuranceEvent({
      insuranceType: 'property',
      cost: [cost, cost, 0],
      value: [value, value, 0],
    });
}

namespace DebentureFactory {
  export const ofz1 = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'ОФЗ выпуск 1',
      profitability: [20, 20, 0],
      price: [price, price, 0],
      nominal: [1000, 1000, 0],
      availableCount: [availableCount, availableCount, 0],
    });

  export const ofz2 = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'ОФЗ выпуск 1',
      profitability: [14, 14, 0],
      price: [price, price, 0],
      nominal: [1000, 1000, 0],
      availableCount: [availableCount, availableCount, 0],
    });

  export const metalPromInvest = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'МеталлПромИнвест',
      profitability: [32, 32, 0],
      price: [price, price, 0],
      nominal: [1000, 1000, 0],
      availableCount: [availableCount, availableCount, 0],
    });

  export const search = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'Поисковик. IT-компания',
      profitability: [45, 45, 0],
      price: [price, price, 0],
      nominal: [1000, 1000, 0],
      availableCount: [availableCount, availableCount, 0],
    });
}

export namespace HookahManEventFactory {
  export const Income = IncomeFactory;
  export const Expense = ExpenseFactory;
  export const Insurace = InsuraceFactory;
  export const Debenture = DebentureFactory;
}
