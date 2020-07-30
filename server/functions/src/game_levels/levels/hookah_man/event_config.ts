import { HookahManEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';
import { GameLevelEventConfig } from '../../models/event_config';

const month = (...events: GameEvent[]) => events;

const month1 = month(
  HookahManEventFactory.Income.tip(1000),
  HookahManEventFactory.Debenture.ofz1(1100, 50),
  HookahManEventFactory.Insurace.healthInsurance(1000, 3000),
  HookahManEventFactory.Stock.nickTeslaAuto(324, 80),
  HookahManEventFactory.Expense.unexpectedRestDay(1500)
);

const month2 = month(
  HookahManEventFactory.Income.workBonus(2500),
  HookahManEventFactory.Stock.gasPromGroup(378, 40),
  HookahManEventFactory.Debenture.search(800, 30),
  HookahManEventFactory.Expense.fine1(1500),
  HookahManEventFactory.Stock.findex(2557, 20)
);

export const eventConfig: GameLevelEventConfig = { events: [month1, month2] };
