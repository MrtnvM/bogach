import * as uuid from 'uuid';
import * as random from 'random';

import { ExpenseEvent } from './expense_event';
import { Game, GameEntity } from '../../models/domain/game/game';
import { randomValueFromRange } from '../../core/data/value_range';

export namespace ExpenseEventGenerator {
  export const generate = (
    game: Game,
    expenseEventInfo: ExpenseEvent.Info[]
  ): ExpenseEvent.Event | undefined => {
    const pastExpenseEvents = GameEntity.getPastEventsOfType<ExpenseEvent.Event>({
      game,
      type: ExpenseEvent.Type,
      maxHistoryLength: 12,
    });

    const alreadyHappenedEvents = {};
    pastExpenseEvents.forEach((e) => (alreadyHappenedEvents[e.name + e.description] = true));

    let filteredExpenseEvents = expenseEventInfo.filter(
      (e) => !alreadyHappenedEvents[e.name + e.description]
    );

    const lastEvent = pastExpenseEvents[0];
    if (lastEvent) {
      filteredExpenseEvents = filteredExpenseEvents.filter(
        (e) => e.insuranceType === lastEvent.data.insuranceType
      );
    }

    if (filteredExpenseEvents.length === 0) {
      return undefined;
    }

    const eventIndex = random.int(0, filteredExpenseEvents.length - 1);
    const eventInfo = filteredExpenseEvents[eventIndex];

    return generateEvent(eventInfo);
  };

  export const generateEvent = (eventInfo: ExpenseEvent.Info): ExpenseEvent.Event => {
    const expense = randomValueFromRange(eventInfo.range);

    return {
      id: uuid.v4(),
      name: eventInfo.name,
      description: eventInfo.description,
      type: ExpenseEvent.Type,
      data: {
        expense,
        insuranceType: eventInfo.insuranceType,
      },
    };
  };
}
