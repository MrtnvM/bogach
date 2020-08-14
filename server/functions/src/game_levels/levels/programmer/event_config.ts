import { ProgrammerEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  ProgrammerEventFactory.Stock.tesla(325, 100),
  ProgrammerEventFactory.Debenture.ofz1(1050, 20),
  ProgrammerEventFactory.Insurace.healthInsurance(700, 4000)
);

const month2 = month(
  ProgrammerEventFactory.Stock.yandex(4100, 10),
  ProgrammerEventFactory.Expense.washingMachine(2000),
  ProgrammerEventFactory.Debenture.pik(1000, 20),
  ProgrammerEventFactory.Income.overworked(1000),
  ProgrammerEventFactory.Stock.yandex(3900, 10)
);

const month3 = month(
  ProgrammerEventFactory.Expense.carBroken(3000),
  ProgrammerEventFactory.Insurace.propertyInsurance(1000, 5000),
  ProgrammerEventFactory.Stock.intel(3200, 10)
);

const month4 = month(
  ProgrammerEventFactory.Income.birthday(4000),
  ProgrammerEventFactory.Stock.tesla(365, 30),
  ProgrammerEventFactory.Debenture.alphabetTase(950, 30),
  ProgrammerEventFactory.Insurace.propertyInsurance(500, 5000)
);

const month5 = month(
  ProgrammerEventFactory.Expense.dentist(4000),
  ProgrammerEventFactory.Stock.intel(2100, 30),
  ProgrammerEventFactory.Stock.yandex(4800, 20),
  ProgrammerEventFactory.Income.debt(5000)
);

const month6 = month(
  ProgrammerEventFactory.Income.cashback(3000),
  ProgrammerEventFactory.Stock.cocaCola(3100, 30),
  ProgrammerEventFactory.Debenture.pik(850, 25),
  ProgrammerEventFactory.Expense.doctor(3000)
);

const month7 = month(
  ProgrammerEventFactory.Stock.intel(2600, 20),
  ProgrammerEventFactory.Expense.clothes(10000),
  ProgrammerEventFactory.Stock.rosneft(350, 100)
);

const month8 = month(
  ProgrammerEventFactory.Expense.cafe(2000),
  ProgrammerEventFactory.Stock.intel(3100, 20),
  ProgrammerEventFactory.Debenture.pik(900, 30),
  ProgrammerEventFactory.Insurace.healthInsurance(600, 4000)
);

const month9 = month(
  ProgrammerEventFactory.Expense.cinema(500),
  ProgrammerEventFactory.Stock.rosneft(340, 100),
  ProgrammerEventFactory.Stock.intel(2000, 8)
);

const month10 = month(
  ProgrammerEventFactory.Stock.intel(2900, 10),
  ProgrammerEventFactory.Stock.rosneft(380, 100),
  ProgrammerEventFactory.Expense.cafe(1500),
  ProgrammerEventFactory.Debenture.pik(1200, 20),
  ProgrammerEventFactory.Income.salaryBonus(10000)
);

const month11 = month(
  ProgrammerEventFactory.Expense.dentist(2000),
  ProgrammerEventFactory.Stock.cocaCola(3300, 15),
  ProgrammerEventFactory.Expense.birthday(1500),
  ProgrammerEventFactory.Debenture.ofz1(900, 30)
);

const month12 = month(
  ProgrammerEventFactory.Stock.tesla(460, 40),
  ProgrammerEventFactory.Debenture.alphabetTase(1050, 40),
  ProgrammerEventFactory.Debenture.ofz1(1150, 30)
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
  ],
};
