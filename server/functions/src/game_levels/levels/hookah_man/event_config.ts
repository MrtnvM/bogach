import { HookahManEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  HookahManEventFactory.Income.tip(1000),
  HookahManEventFactory.Debenture.ofz1(1100, 20),
  HookahManEventFactory.Insurace.healthInsurance(1000, 3000),
  HookahManEventFactory.Stock.nickTeslaAuto(324, 80),
  HookahManEventFactory.Expense.unexpectedRestDay(1500)
);

const month2 = month(
  HookahManEventFactory.MonthlyExpense.englishLessons(),
  HookahManEventFactory.Income.workBonus(2500),
  HookahManEventFactory.Stock.gasPromGroup(378, 40),
  HookahManEventFactory.Debenture.search(800, 30),
  HookahManEventFactory.Expense.fine1(1500),
  HookahManEventFactory.Stock.findex(2557, 20)
);

const month3 = month(
  HookahManEventFactory.Debenture.metalPromInvest(1300, 40),
  HookahManEventFactory.Stock.nickTeslaAuto(589, 30),
  HookahManEventFactory.Expense.cinema(500),
  HookahManEventFactory.Debenture.ofz2(1300, 20),
  HookahManEventFactory.Stock.findex(2809, 20)
);

const month4 = month(
  HookahManEventFactory.Income.workBonus(1200),
  HookahManEventFactory.Expense.cafe(1500),
  HookahManEventFactory.Stock.sberInvestBank(245, 25),
  HookahManEventFactory.Debenture.search(900, 8),
  HookahManEventFactory.Insurace.propertyInsurance(2000, 5000)
);

const month5 = month(
  HookahManEventFactory.Expense.computerRepair(3500),
  HookahManEventFactory.Income.tip(500),
  HookahManEventFactory.Debenture.ofz1(800, 20),
  HookahManEventFactory.Stock.gasPromGroup(410, 30)
);

const month6 = month(
  HookahManEventFactory.Insurace.healthInsurance(2000, 3000),
  HookahManEventFactory.Stock.sberInvestBank(308, 20),
  HookahManEventFactory.Debenture.search(1050, 20),
  HookahManEventFactory.Expense.fine3(1500),
  HookahManEventFactory.Stock.findex(2330, 25)
);

const month7 = month(
  HookahManEventFactory.Income.tip(600),
  HookahManEventFactory.Debenture.ofz2(1100, 20),
  HookahManEventFactory.Expense.dentist(3000),
  HookahManEventFactory.Stock.nickTeslaAuto(500, 10),
  HookahManEventFactory.Expense.unexpectedRestDay(1000)
);

export const eventConfig: GameLevelEventConfig = {
  events: [month1, month2, month3, month4, month5, month6, month7],
};
