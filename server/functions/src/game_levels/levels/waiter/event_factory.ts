import { EventFactory } from '../../../factory/event_factory';
import { valueRange } from '../../../core/data/value_range';

namespace IncomeFactory {
  export const workBonus = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Премия',
      description: 'Сегодня гостей было больше чем обычно. Небольшой процент с продаж - ваш!',
      range: valueRange(value),
    });

  export const tip = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Чаевые',
      description: 'Гости оставили вам чаевые!',
      range: valueRange(value),
    });

  export const debt = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Друг вернул долг',
      description: 'Ваш друг вернул долг, про который вы забыли',
      range: valueRange(value),
    });

  export const saleThing = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Вы продали ненужную вещь',
      description: 'Вы перестали играть в PlayStation 4 и решили ее продать',
      range: valueRange(value),
    });
}

namespace ExpenseFactory {
  export const fine1 = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Штраф',
      description: 'Вы получили штраф на работе',
      insuranceType: null,
      range: valueRange(value),
    });

  export const fine3 = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Штраф',
      description: 'Клиент ушел не заплатив',
      insuranceType: null,
      range: valueRange(value),
    });

  export const doctor = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Здоровье',
      description: 'Внеплановое посещение врача',
      insuranceType: 'health',
      range: valueRange(value),
    });

  export const dentist = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Здоровье',
      description: 'Вы посетили стоматолога',
      insuranceType: 'health',
      range: valueRange(value),
    });

  export const cafe = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Развлечения',
      description: 'Вы с друзьями сходили в кафе',
      insuranceType: null,
      range: valueRange(value),
    });

  export const cinema = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Развлечения',
      description: 'Посещение премьеры фильма',
      insuranceType: null,
      range: valueRange(value),
    });

  export const computerRepair = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Техника',
      description: 'Сломался компьютер. Необходим ремонт',
      insuranceType: 'property',
      range: valueRange(value),
    });
}

namespace InsuranceFactory {
  export const healthInsurance = (cost: number, value: number) =>
    EventFactory.insuranceEvent({
      insuranceType: 'health',
      cost: valueRange(cost),
      value: valueRange(value),
    });

  export const propertyInsurance = (cost: number, value: number) =>
    EventFactory.insuranceEvent({
      insuranceType: 'property',
      cost: valueRange(cost),
      value: valueRange(value),
    });
}

namespace DebentureFactory {
  export const ofz1 = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'ОФЗ выпуск 1',
      profitability: valueRange(20),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

  export const ofz2 = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'ОФЗ выпуск 2',
      profitability: valueRange(14),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

  export const metalPromInvest = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'МеталлПромИнвест',
      profitability: valueRange(32),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

  export const search = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'Поисковик. IT-компания',
      profitability: valueRange(45),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });
}

namespace StockFactory {
  export const findex = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'FINDEX',
      currentPrice: valueRange(price),
      fairPrice: valueRange(2540),
      availableCount: valueRange(availableCount),
      candles: [],
    });

  export const gasPromGroup = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Газ Пром Групп',
      currentPrice: valueRange(price),
      fairPrice: valueRange(360),
      availableCount: valueRange(availableCount),
      candles: [],
    });

  export const sberInvestBank = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'СберИнвестБанк',
      currentPrice: valueRange(price),
      fairPrice: valueRange(240),
      availableCount: valueRange(availableCount),
      candles: [],
    });

  export const nickTeslaAuto = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Nick Tesla Auto',
      currentPrice: valueRange(price),
      fairPrice: valueRange(525),
      availableCount: valueRange(availableCount),
      candles: [],
    });
}

export namespace MonthlyExpenseFactory {
  export const fitness = () =>
    EventFactory.monthlyExpenseEvent({
      name: 'Занятия спортом',
      description: 'Вы начали ходить в спортзал. Ежемесячные расходы увеличены.',
      value: valueRange(1000),
      expenseName: 'Занятия спортом',
    });
}

export namespace WaiterEventFactory {
  export const Income = IncomeFactory;
  export const Expense = ExpenseFactory;
  export const Insurance = InsuranceFactory;
  export const Debenture = DebentureFactory;
  export const Stock = StockFactory;
  export const MonthlyExpense = MonthlyExpenseFactory;
}
