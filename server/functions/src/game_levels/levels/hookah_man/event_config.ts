import { HookahManEventFactory } from './event_factory';
import { GameEvent } from '../../../models/domain/game/game_event';

const day = (...events: GameEvent[]) => events;

const day1 = day(
  HookahManEventFactory.Income.tip(1000),
  HookahManEventFactory.Expense.unexpectedRestDay(1500)
);

const day2 = day(
  HookahManEventFactory.Income.workBonus(2500),
  HookahManEventFactory.Expense.fine1(1500)
);

export const monthEvents: GameEvent[][] = [day1, day2];
