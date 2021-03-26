import { EventFactory } from '../../../factory/event_factory';
import { valueRange } from '../../../core/data/value_range';

namespace IncomeFactory {
  export const birthday = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Подарок',
      description: 'Вы отметили день рождения, и друзья сделали вам подарок!',
      range: valueRange(value),
    });

  export const instaGuides = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Продажа',
      description:
        'Ваш инстаграм привлёк новых клиентов, ' +
        'и вы продали гайды по психологическому спокойствию',
      range: valueRange(value),
    });

  export const scienceArticle = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Научная статья',
      description: 'Продажа статьи в научный журнал',
      range: valueRange(value),
    });

  export const onlineConsulting = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Новый клиент',
      description: 'Вы получили нового клиента и провели консультацию',
      range: valueRange(value),
    });

  export const instagramClient = (value: number) =>
    EventFactory.incomeEvent({
      name: 'Новые клиенты',
      description: 'Удалось привлечь новых клиентов благодаря блогу в Instagram',
      range: valueRange(value),
    });
}

namespace ExpenseFactory {
  export const vacationSeason = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Сезон отпусков',
      description: 'В этом месяце сезон отпусков - количество клиентов сократилось в 2 раза',
      insuranceType: null,
      range: valueRange(value),
    });

  export const illedChild = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Отмена сеанса',
      description: 'Заболел ребенок, вы взяли больничный',
      insuranceType: null,
      range: valueRange(value),
    });

  export const unexpectedRestDay = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Внеплановый выходной',
      description: 'Отключили электричество в офисе - пришлось отменить сеансы',
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

  export const tvRepair = (value: number) =>
    EventFactory.expenseEvent({
      name: 'Техника',
      description: 'Сломался телевизор. Необходим ремонт',
      insuranceType: 'property',
      range: valueRange(value),
    });
}

namespace SalaryChangeFactory {
  export const clientGone = (value: number) =>
    EventFactory.salaryChangeEvent({
      name: 'Изменение в зарплате',
      description: 'Клиент ушел к другому специалисту',
      value: valueRange(value),
    });

  export const newClient = (value: number) =>
    EventFactory.salaryChangeEvent({
      name: 'Изменение в зарплате',
      description: 'Пришел новый клиент по рекомендации от другого клиента',
      value: valueRange(value),
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

  export const rosNanoTech = (price: number, availableCount: number) =>
    EventFactory.debentureEvent({
      name: 'РосНаноТех',
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
  export const apple = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Apple Electronics',
      currentPrice: valueRange(price),
      fairPrice: valueRange(1250),
      availableCount: valueRange(availableCount),
      candles: [],
    });

  export const gasPromGroup = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'Газ Пром Групп',
      currentPrice: valueRange(price),
      fairPrice: valueRange(350),
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

  export const vwAuto = (price: number, availableCount: number) =>
    EventFactory.stockEvent({
      name: 'VW Auto',
      currentPrice: valueRange(price),
      fairPrice: valueRange(235),
      availableCount: valueRange(availableCount),
      candles: [],
    });
}

export namespace PsychologistEventFactory {
  export const Income = IncomeFactory;
  export const Expense = ExpenseFactory;
  export const SalaryChange = SalaryChangeFactory;
  export const Insurance = InsuranceFactory;
  export const Debenture = DebentureFactory;
  export const Stock = StockFactory;
}
