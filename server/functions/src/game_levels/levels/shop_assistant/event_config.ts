import { ShopAssistantEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  ShopAssistantEventFactory.Income.saleThing(1500),
  ShopAssistantEventFactory.Stock.nickTeslaAuto(401, 60),
  ShopAssistantEventFactory.Expense.doctor(1350),
  ShopAssistantEventFactory.Debenture.alphabetTaste(1050, 20),
  ShopAssistantEventFactory.Expense.dentist(2500)
);

const month2 = month(
  ShopAssistantEventFactory.Income.workBonus(3000),
  ShopAssistantEventFactory.Debenture.ofz2(1100, 30),
  ShopAssistantEventFactory.Stock.sberInvestBank(220, 40),
  ShopAssistantEventFactory.Stock.nickTeslaAuto(450, 30),
  ShopAssistantEventFactory.Debenture.alphabetTaste(1050, 20)
);

const month3 = month(
  ShopAssistantEventFactory.Debenture.metalPromInvest(900, 35),
  ShopAssistantEventFactory.Debenture.ofz2(1300, 20),
  ShopAssistantEventFactory.Debenture.alphabetTaste(1070, 20),
  ShopAssistantEventFactory.Debenture.search(1000, 20),
  ShopAssistantEventFactory.Insurance.propertyInsurance(2000, 5000)
);

const month4 = month(
  ShopAssistantEventFactory.Income.saleThing(1500),
  ShopAssistantEventFactory.Debenture.ofz1(1200, 20),
  ShopAssistantEventFactory.Insurance.healthInsurance(700, 3700),
  ShopAssistantEventFactory.Stock.gasPromGroup(370, 40),
  ShopAssistantEventFactory.Debenture.ofz1(930, 20),
  ShopAssistantEventFactory.Expense.dentist(1500),
  ShopAssistantEventFactory.Stock.nickTeslaAuto(575, 10)
);

const month5 = month(
  ShopAssistantEventFactory.Expense.phoneRepair(3500),
  ShopAssistantEventFactory.Expense.cafe(700),
  ShopAssistantEventFactory.Debenture.search(1150, 20),
  ShopAssistantEventFactory.Expense.fine1(1000),
  ShopAssistantEventFactory.Stock.gasPromGroup(410, 40)
);

const month6 = month(
  ShopAssistantEventFactory.Income.debt(2000),
  ShopAssistantEventFactory.MonthlyExpense.fitness(),
  ShopAssistantEventFactory.Debenture.ofz1(1100, 25),
  ShopAssistantEventFactory.Insurance.healthInsurance(1500, 3000),
  ShopAssistantEventFactory.Expense.friendBirthday(3000),
  ShopAssistantEventFactory.Stock.findex(2130, 30)
);

const month7 = month(
  ShopAssistantEventFactory.Stock.gasPromGroup(320, 30),
  ShopAssistantEventFactory.Income.workBonus(1500),
  ShopAssistantEventFactory.Debenture.search(800, 30),
  ShopAssistantEventFactory.Stock.findex(2450, 25),
  ShopAssistantEventFactory.Stock.sberInvestBank(250, 30)
);

const month8 = month(
  ShopAssistantEventFactory.Debenture.search(1050, 8),
  ShopAssistantEventFactory.Expense.cafe(700),
  ShopAssistantEventFactory.Stock.nickTeslaAuto(560, 10),
  ShopAssistantEventFactory.Stock.nickTeslaAuto(610, 30)
);

const month9 = month(
  ShopAssistantEventFactory.Income.saleThing(1500),
  ShopAssistantEventFactory.Expense.cafe(700),
  ShopAssistantEventFactory.Stock.findex(2450, 20),
  ShopAssistantEventFactory.Stock.gasPromGroup(415, 30),
  ShopAssistantEventFactory.Stock.sberInvestBank(230, 30),
  ShopAssistantEventFactory.Expense.cinema(500)
);

export const eventConfig: GameLevelEventConfig = {
  events: [month1, month2, month3, month4, month5, month6, month7, month8, month9],
};
