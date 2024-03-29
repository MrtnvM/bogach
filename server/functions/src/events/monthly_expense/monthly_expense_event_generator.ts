import * as uuid from 'uuid';
import * as random from 'random';

import { MonthlyExpenseEvent } from './monthly_expense_event';
import { Game, GameEntity } from '../../models/domain/game/game';
import { randomValueFromRange } from '../../core/data/value_range';

export namespace MonthlyExpenseEventGenerator {
  export const generate = (
    game: Game,
    expenseEventInfo: MonthlyExpenseEvent.Info[],
    maxHistoryLength: number
  ): MonthlyExpenseEvent.Event | undefined => {
    const pastExpenseEvents = GameEntity.getPastEventsOfType<MonthlyExpenseEvent.Event>({
      game,
      type: MonthlyExpenseEvent.Type,
      maxHistoryLength,
    });

    const alreadyHappenedEvents = {};
    pastExpenseEvents.forEach((e) => (alreadyHappenedEvents[e.name + e.description] = true));

    const filteredExpenseEvents = expenseEventInfo.filter(
      (e) => !alreadyHappenedEvents[e.name + e.description]
    );

    if (filteredExpenseEvents.length === 0) {
      return undefined;
    }

    const eventIndex = random.int(0, filteredExpenseEvents.length - 1);
    const eventInfo = filteredExpenseEvents[eventIndex];

    return generateEvent(eventInfo);
  };

  export const generateEvent = (eventInfo: MonthlyExpenseEvent.Info): MonthlyExpenseEvent.Event => {
    const { name, description, expenseName, value } = eventInfo;
    const monthlyPayment = randomValueFromRange(value);

    return {
      id: uuid.v4(),
      name,
      description,
      type: MonthlyExpenseEvent.Type,
      data: {
        expenseName,
        monthlyPayment,
      },
    };
  };
}
