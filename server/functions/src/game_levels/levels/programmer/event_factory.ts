import { EventFactory } from '../../../factory/event_factory';
import { valueRange } from '../../../core/data/value_range';

namespace IncomeFactory {
  export const birthday = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Подарок',
      description: 'Вы отметили день рождения и друзья сделали вам подарок!',
      range: valueRange(value),
    });

  export const overworked = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Переработка в офисе',
      description: 'Вы поработали сверхурочно в этом месяце',
      range: valueRange(value),
    });

  export const cashback = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Повышенный кешбек',
      description: 'Ваши крупные расходы попали под повышенный кешбек',
      range: valueRange(value),
    });

  export const debt = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Друг вернул долг',
      description: 'Ваш друг вернул долг, про который вы забыли',
      range: valueRange(value),
    });

  export const salaryBonus = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Премия на работе',
      description: 'Вы закончили проект вовремя и получили премию',
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
  export const washingMachine = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Непредвиденные траты на вызов мастера',
      description: 'Сломалась стиральная машина',
      insuranceType: null,
      range: valueRange(value),
    });

  export const carBroken = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Непредвиденные траты на ремонт авто',
      description: 'Вашу машину во дворе кто-то поцарапал',
      insuranceType: 'property',
      range: valueRange(value),
    });

  export const birthday = (value: number) =>
    EventFactory.expenseEvent({
      name: 'День Рождения друга',
      description: 'Вы купили подарок своему другу на День Рождения',
      insuranceType: null,
      range: valueRange(value),
    });

  export const doctor = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Здоровье',
      description: 'Внеплановое посещение врача + покупка лекарств',
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

  export const clothes = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Обновили гардероб',
      description: 'Вы купили себе новые вещи для медового месяца',
      insuranceType: null,
      range: valueRange(value),
    });
}

namespace InsuraceFactory {
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
      profitability: valueRange(6),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

  export const pik = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'ПИК-Корпорация выпуск 2',
      profitability: valueRange(8),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

  export const alphabetTase = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'Азбука Вкуса выпуск 1',
      profitability: valueRange(9),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });
}

namespace StockFactory {
  export const tesla = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Tesla',
      currentPrice: valueRange(price),
      fairPrice: valueRange(320),
      availableCount: valueRange(availableCount),
    });

  export const yandex = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Яндекс',
      currentPrice: valueRange(price),
      fairPrice: valueRange(4450),
      availableCount: valueRange(availableCount),
    });

  export const cocaCola = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'COCA-COLA',
      currentPrice: valueRange(price),
      fairPrice: valueRange(3100),
      availableCount: valueRange(availableCount),
    });

  export const intel = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Intel',
      currentPrice: valueRange(price),
      fairPrice: valueRange(2850),
      availableCount: valueRange(availableCount),
    });

  export const rosneft = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Роснефть',
      currentPrice: valueRange(price),
      fairPrice: valueRange(380),
      availableCount: valueRange(availableCount),
    });
}

export namespace ProgrammerEventFactory {
  export const Income = IncomeFactory;
  export const Expense = ExpenseFactory;
  export const Insurace = InsuraceFactory;
  export const Debenture = DebentureFactory;
  export const Stock = StockFactory;
}
