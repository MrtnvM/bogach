import { ProgrammerEventFactory as ManagerEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  ManagerEventFactory.Expense.dentist(3000),
  ManagerEventFactory.Stock.cocaCola(3350, 10),
  ManagerEventFactory.Expense.birthday(2000),
  ManagerEventFactory.Debenture.pik(920, 30)
);

const month2 = month(
  ManagerEventFactory.Stock.tesla(290, 40),
  ManagerEventFactory.Debenture.alphabetTaste(1050, 40),
  ManagerEventFactory.Debenture.ofz1(1150, 30)
);

const month3 = month(
  ManagerEventFactory.Expense.cafe(1500),
  ManagerEventFactory.Stock.rosneft(320, 100),
  ManagerEventFactory.Stock.intel(1900, 10),
  ManagerEventFactory.Debenture.pik(1000, 20)
);

const month4 = month(
  ManagerEventFactory.Income.cashback(3000),
  ManagerEventFactory.Stock.cocaCola(2900, 30),
  ManagerEventFactory.Debenture.pik(850, 25),
  ManagerEventFactory.Expense.doctor(3000),
  ManagerEventFactory.Income.salaryBonus1(4000)
);

const month5 = month(
  ManagerEventFactory.Stock.intel(2900, 10),
  ManagerEventFactory.Stock.rosneft(390, 100),
  ManagerEventFactory.Expense.cinema(1500),
  ManagerEventFactory.Income.saleFlat(5000)
);

const month6 = month(
  ManagerEventFactory.Stock.intel(2600, 20),
  ManagerEventFactory.Expense.clothes(10000),
  ManagerEventFactory.Stock.rosneft(450, 100),
  ManagerEventFactory.Stock.gas(170, 150),
);

const month7 = month(
  ManagerEventFactory.Expense.dentist(4000),
  ManagerEventFactory.Stock.intel(2100, 30),
  ManagerEventFactory.Stock.intel(2000, 12),
  ManagerEventFactory.Debenture.ofz1(1200, 20)
);

const month8 = month(
  ManagerEventFactory.Income.birthday(4000),
  ManagerEventFactory.Stock.tesla(365, 30),
  ManagerEventFactory.Debenture.alphabetTaste(900, 30),
  ManagerEventFactory.Insurace.propertyInsurance(500, 5000)
);

const month9 = month(
  ManagerEventFactory.Expense.carBroken(3000),
  ManagerEventFactory.Stock.intel(3200, 10)
);

const month10 = month(
  ManagerEventFactory.Expense.cafe(2000),
  ManagerEventFactory.Stock.intel(3100, 20),
  ManagerEventFactory.Debenture.pik(900, 30),
  ManagerEventFactory.Stock.cocaCola(3100, 30),
  ManagerEventFactory.Insurace.propertyInsurance(1000, 5000),
  ManagerEventFactory.Insurace.healthInsurance(600, 4000)
);

const month11 = month(
  ManagerEventFactory.Stock.tesla(325, 100),
  ManagerEventFactory.Debenture.ofz1(1050, 20),
  ManagerEventFactory.Insurace.healthInsurance(700, 4000),
  ManagerEventFactory.Debenture.alphabetTaste(1100, 30),
);

const month12 = month(
  ManagerEventFactory.Stock.yandex(4100, 10),
  ManagerEventFactory.Expense.washingMachine(2000),
  ManagerEventFactory.Income.overworked(1000),
  ManagerEventFactory.Stock.yandex(3900, 10)
);

const month13 = month(
  ManagerEventFactory.Income.cashback(3000),
  ManagerEventFactory.Debenture.pik(850, 25),
  ManagerEventFactory.Income.saleThing(3000),
);

const month14 = month(
  ManagerEventFactory.Expense.cafe(1500),
  ManagerEventFactory.Stock.gas(230, 100),
  ManagerEventFactory.Income.salaryBonus2(10000),
  ManagerEventFactory.Stock.yandex(4800, 20),
  ManagerEventFactory.Debenture.pik(1020, 25),
);

export const eventConfig: GameLevelEventConfig = {
  events: [
    month1,
    month2,
    month3,
    month4,
    month5,
    month6,
    month7,
    month8,
    month9,
    month10,
    month11,
    month12,
    month13,
    month14,
  ],
};
