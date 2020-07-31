import { EventFactory } from '../../../factory/event_factory';
import { valueRange } from '../../../core/data/value_range';

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

namespace StockFactory {
  export const findex = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'FINDEX',
      price: valueRange(price),
      fairPrice: valueRange(2540),
      availableCount: valueRange(availableCount),
    });

  export const gasPromGroup = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Газ Пром Групп',
      price: valueRange(price),
      fairPrice: valueRange(360),
      availableCount: valueRange(availableCount),
    });

  export const sberInvestBank = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'СберИнвестБанк',
      price: valueRange(price),
      fairPrice: valueRange(240),
      availableCount: valueRange(availableCount),
    });

  export const metalPromInvest = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'МеталлПромИнвест',
      price: valueRange(price),
      fairPrice: valueRange(24),
      availableCount: valueRange(availableCount),
    });

  export const nickTeslaAuto = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Nick Tesla Auto',
      price: valueRange(price),
      fairPrice: valueRange(525),
      availableCount: valueRange(availableCount),
    });
}

export namespace MonthlyExpenseFactory {
  export const englishLessons = () =>
    EventFactory.monthlyExpenseEvent({
      name: 'Уроки английского',
      description:
        'Для запланированного путешествия необходимо пройти курс английского. ' +
        'Eжемесячные расходы увеличены.',
      value: valueRange(1000),
      expenseName: 'Уроки английского',
    });
}

export namespace HookahManEventFactory {
  export const Income = IncomeFactory;
  export const Expense = ExpenseFactory;
  export const Insurace = InsuraceFactory;
  export const Debenture = DebentureFactory;
  export const Stock = StockFactory;
  export const monthlyExpenseEvent = MonthlyExpenseFactory;
}
