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

    const alreadyHappendEvents = {};
    pastExpenseEvents.forEach((e) => (alreadyHappendEvents[e.name + e.description] = true));

    let filtredExpenseEvents = expenseEventInfo.filter(
      (e) => !alreadyHappendEvents[e.name + e.description]
    );

    const lastEvent = pastExpenseEvents[0];
    if (lastEvent) {
      filtredExpenseEvents = filtredExpenseEvents.filter(
        (e) => e.insuranceType === lastEvent.data.insuranceType
      );
    }

    if (filtredExpenseEvents.length === 0) {
      return undefined;
    }

    const eventIndex = random.int(0, filtredExpenseEvents.length - 1);
    const eventInfo = filtredExpenseEvents[eventIndex];
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
