import { PsychologistEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  PsychologistEventFactory.Debenture.ofz1(1100, 20),
  PsychologistEventFactory.Insurace.healthInsurance(1000, 3000),
  PsychologistEventFactory.Stock.nickTeslaAuto(324, 80),
  PsychologistEventFactory.Expense.unexpectedRestDay(1200)
);

const month2 = month(
  PsychologistEventFactory.MonthlyExpense.englishLessons(),
  PsychologistEventFactory.Stock.gasPromGroup(378, 40),
  PsychologistEventFactory.Debenture.search(800, 30),
  PsychologistEventFactory.Expense.fine1(1000),
  PsychologistEventFactory.Stock.findex(2557, 20)
);

const month3 = month(
  PsychologistEventFactory.Debenture.metalPromInvest(1300, 40),
  PsychologistEventFactory.Stock.nickTeslaAuto(589, 30),
  PsychologistEventFactory.Expense.cinema(500),
  PsychologistEventFactory.Debenture.ofz2(1300, 20),
  PsychologistEventFactory.Stock.findex(2809, 20)
);

const month4 = month(
  PsychologistEventFactory.Expense.cafe(1500),
  PsychologistEventFactory.Stock.sberInvestBank(245, 25),
  PsychologistEventFactory.Debenture.search(900, 8),
  PsychologistEventFactory.Expense.canceledWorkBonus(500),
  PsychologistEventFactory.Insurace.propertyInsurance(2000, 5000)
);

const month5 = month(
  PsychologistEventFactory.Expense.computerRepair(3500),
  PsychologistEventFactory.Debenture.ofz1(800, 20),
  PsychologistEventFactory.Stock.gasPromGroup(410, 30)
);

const month6 = month(
  PsychologistEventFactory.Insurace.healthInsurance(2000, 3000),
  PsychologistEventFactory.Stock.sberInvestBank(308, 20),
  PsychologistEventFactory.Debenture.search(1050, 20),
  PsychologistEventFactory.Expense.fine3(1000),
  PsychologistEventFactory.Stock.findex(2330, 25)
);

const month7 = month(
  PsychologistEventFactory.Debenture.ofz2(1100, 20),
  PsychologistEventFactory.Expense.dentist(3000),
  PsychologistEventFactory.Stock.nickTeslaAuto(500, 10),
  PsychologistEventFactory.Expense.unexpectedRestDay(1000)
);

const month8 = month(
  PsychologistEventFactory.Debenture.ofz2(1100, 20),
  PsychologistEventFactory.Expense.dentist(3000),
  PsychologistEventFactory.Stock.nickTeslaAuto(500, 10),
  PsychologistEventFactory.Expense.unexpectedRestDay(1000)
);

const month9 = month(
  PsychologistEventFactory.Debenture.ofz2(1100, 20),
  PsychologistEventFactory.Expense.dentist(3000),
  PsychologistEventFactory.Stock.nickTeslaAuto(500, 10),
  PsychologistEventFactory.Expense.unexpectedRestDay(1000)
);

const month10 = month(
  PsychologistEventFactory.Debenture.ofz2(1100, 20),
  PsychologistEventFactory.Expense.dentist(3000),
  PsychologistEventFactory.Stock.nickTeslaAuto(500, 10),
  PsychologistEventFactory.Expense.unexpectedRestDay(1000)
);

export const eventConfig: GameLevelEventConfig = {
  events: [month1, month2, month3, month4, month5, month6, month7, month8, month9, month10],
};
