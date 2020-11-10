import { PsychologistEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  PsychologistEventFactory.Insurance.healthInsurance(1000, 5000),
  PsychologistEventFactory.Stock.vwAuto(210, 50),
  PsychologistEventFactory.Debenture.ofz1(900, 20),
  PsychologistEventFactory.Income.birthday(3000)
);

const month2 = month(
  PsychologistEventFactory.Debenture.rosNanoTech(1200, 20),
  PsychologistEventFactory.Expense.unexpectedRestDay(1500),
  PsychologistEventFactory.Stock.apple(1100, 10),
  PsychologistEventFactory.Income.instaGuides(2000),
  PsychologistEventFactory.Debenture.search(900, 20)
);

const month3 = month(
  PsychologistEventFactory.Expense.dentist(4000),
  PsychologistEventFactory.Stock.vwAuto(250, 30),
  PsychologistEventFactory.Debenture.ofz1(900, 10),
  PsychologistEventFactory.SalaryChange.clientGone(-1500),
  PsychologistEventFactory.Stock.gasPromGroup(320, 30)
);

const month4 = month(
  PsychologistEventFactory.Expense.cafe(800),
  PsychologistEventFactory.Stock.sberInvestBank(225, 25),
  PsychologistEventFactory.Debenture.search(900, 8),
  PsychologistEventFactory.Insurance.propertyInsurance(2000, 5000)
);

const month5 = month(
  PsychologistEventFactory.SalaryChange.newClient(1500),
  PsychologistEventFactory.Expense.cinema(500),
  PsychologistEventFactory.Debenture.ofz1(800, 20),
  PsychologistEventFactory.Stock.gasPromGroup(410, 30)
);

const month6 = month(
  PsychologistEventFactory.Insurance.healthInsurance(1500, 4000),
  PsychologistEventFactory.Stock.sberInvestBank(320, 20),
  PsychologistEventFactory.Debenture.search(1100, 25),
  PsychologistEventFactory.Expense.tvRepair(2000),
  PsychologistEventFactory.Income.onlineConsulting(1300)
);

const month7 = month(
  PsychologistEventFactory.Stock.sberInvestBank(200, 15),
  PsychologistEventFactory.Expense.doctor(5000),
  PsychologistEventFactory.Stock.vwAuto(230, 15),
  PsychologistEventFactory.SalaryChange.newClient(1500)
);

const month8 = month(
  PsychologistEventFactory.Expense.illedChild(2000),
  PsychologistEventFactory.Stock.apple(1800, 10),
  PsychologistEventFactory.Debenture.search(1050, 15),
  PsychologistEventFactory.Insurance.propertyInsurance(2000, 4000)
);

const month9 = month(
  PsychologistEventFactory.Expense.dentist(1000),
  PsychologistEventFactory.Stock.vwAuto(240, 10),
  PsychologistEventFactory.Expense.cafe(800),
  PsychologistEventFactory.Debenture.ofz1(900, 10),
  PsychologistEventFactory.Income.scienceArticle(4500)
);

const month10 = month(
  PsychologistEventFactory.SalaryChange.newClient(1500),
  PsychologistEventFactory.Stock.vwAuto(500, 10),
  PsychologistEventFactory.Expense.cinema(600),
  PsychologistEventFactory.Debenture.rosNanoTech(1200, 20)
);

export const eventConfig: GameLevelEventConfig = {
  events: [month1, month2, month3, month4, month5, month6, month7, month8, month9, month10],
};
