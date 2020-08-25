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

  export const salaryBonus1 = (value: number) =>
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

  export const salaryBonus2 = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Премия на работе',
      description: 'На работе выдали годовую премию',
      range: valueRange(value),
    });

  export const saleFlat = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Арендодатель сделал вам скидку',
      description:
        'На рынке недвижимости произошёл спад спроса - арендодатель сделал вам разовую скидку',
      range: valueRange(value),
    });
}

namespace ExpenseFactory {
  export const washingMachine = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Непредвиденные траты на вызов мастера',
      description: 'Сломалася холодильник',
      insuranceType: null,
      range: valueRange(value),
    });

  export const carBroken = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Непредвиденные траты на ремонт авто',
      description: 'Пришлось заплатить за эвакуатор и ремонт',
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
      name: 'Обновиление гардероба',
      description: 'Вы решили сменить стиль',
      insuranceType: null,
      range: valueRange(value),
    });

  export const musicConcert = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Посещение концерт',
      description: 'Вы посетили музыкальный концерт',
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
      profitability: valueRange(15),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

  export const pik = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: '"ЖилЗастройщик" выпуск 2',
      profitability: valueRange(16),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

  export const alphabetTaste = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: '"Вкусные Продукты" выпуск 1',
      profitability: valueRange(17),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });

    export const goldMiner = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: '"Золотодобытчик" выпуск 1',
      profitability: valueRange(17),
      price: valueRange(price),
      nominal: valueRange(1000),
      availableCount: valueRange(availableCount),
    });
}

namespace StockFactory {
  export const tesla = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Nick Tesla Auto',
      currentPrice: valueRange(price),
      fairPrice: valueRange(320),
      availableCount: valueRange(availableCount),
    });

  export const yandex = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Группа ИТ компаний',
      currentPrice: valueRange(price),
      fairPrice: valueRange(4450),
      availableCount: valueRange(availableCount),
    });

  export const cocaCola = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'DrinkingCompany',
      currentPrice: valueRange(price),
      fairPrice: valueRange(3100),
      availableCount: valueRange(availableCount),
    });

  export const intel = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'MicroprocessorCo',
      currentPrice: valueRange(price),
      fairPrice: valueRange(2850),
      availableCount: valueRange(availableCount),
    });

  export const rosneft = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'РусНефть',
      currentPrice: valueRange(price),
      fairPrice: valueRange(380),
      availableCount: valueRange(availableCount),
    });

    export const gas = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'ГазПромышленность',
      currentPrice: valueRange(price),
      fairPrice: valueRange(200),
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
