import { WaiterEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  WaiterEventFactory.Income.tip(1000),
  WaiterEventFactory.Stock.nickTeslaAuto(340, 80),
  WaiterEventFactory.Expense.doctor(1200),
  WaiterEventFactory.Expense.fine3(1000),
  WaiterEventFactory.Stock.findex(2130, 5)
);

const month2 = month(
  WaiterEventFactory.Income.workBonus(2500),
  WaiterEventFactory.Stock.gasPromGroup(389, 40),
  WaiterEventFactory.Stock.sberInvestBank(245, 25),
  WaiterEventFactory.Expense.dentist(2000)
);

const month3 = month(
  WaiterEventFactory.Income.debt(2000),
  WaiterEventFactory.Debenture.metalPromInvest(850, 20),
  WaiterEventFactory.Stock.nickTeslaAuto(610, 30),
  WaiterEventFactory.Expense.cinema(500),
  WaiterEventFactory.Debenture.search(800, 30),
  WaiterEventFactory.Expense.fine1(1000),
  WaiterEventFactory.Stock.findex(2570, 20)
);

const month4 = month(
  WaiterEventFactory.Debenture.ofz1(1100, 20),
  WaiterEventFactory.Insurace.healthInsurance(800, 3500),
  WaiterEventFactory.Income.workBonus(1500),
  WaiterEventFactory.Debenture.ofz2(1300, 20),
  WaiterEventFactory.Debenture.ofz1(800, 20),
  WaiterEventFactory.Debenture.search(1150, 20)
);

const month5 = month(
  WaiterEventFactory.Expense.computerRepair(3500),
  WaiterEventFactory.Expense.cafe(500),
  WaiterEventFactory.Debenture.search(900, 20),
  WaiterEventFactory.Insurace.propertyInsurance(2000, 5000)
);

const month6 = month(
  WaiterEventFactory.MonthlyExpense.fitness(),
  WaiterEventFactory.Income.workBonus(1800),
  WaiterEventFactory.Expense.cafe(700),
  WaiterEventFactory.Insurace.healthInsurance(1500, 3000),
  WaiterEventFactory.Stock.sberInvestBank(308, 20),
  WaiterEventFactory.Stock.gasPromGroup(410, 30)
);

const month7 = month(
  WaiterEventFactory.Income.tip(600),
  WaiterEventFactory.Stock.gasPromGroup(320, 30),
  WaiterEventFactory.Stock.nickTeslaAuto(450, 10),
  WaiterEventFactory.Stock.findex(3000, 20)
);

const month8 = month(
  WaiterEventFactory.Income.saleThing(1500),
  WaiterEventFactory.Debenture.ofz1(1200, 20),
  WaiterEventFactory.Debenture.ofz2(1200, 20),
  WaiterEventFactory.Expense.dentist(3000),
  WaiterEventFactory.Debenture.search(1050, 8),
  WaiterEventFactory.Stock.nickTeslaAuto(560, 10)
);

export const eventConfig: GameLevelEventConfig = {
  events: [month1, month2, month3, month4, month5, month6, month7, month8],
};
