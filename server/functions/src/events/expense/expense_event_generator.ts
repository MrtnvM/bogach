import * as uuid from 'uuid';
import * as random from 'random';

import { ExpenseEvent } from './expense_event';
import { Game } from '../../models/domain/game/game';
import { ExpenseGeneratorConfig } from './expense_generator_config';
import { randomValueFromRange } from '../../core/data/value_range';

export namespace ExpenseEventGenerator {
  export const generate = (game: Game): ExpenseEvent.Event | undefined => {
    const historyLength = Math.min(game.history.months.length, 12);
    const history = game.history.months.slice(historyLength);

    const pastExpenseEvents = history
      .map((month) => month.events.filter((e) => e.type === ExpenseEvent.Type))
      .reduce((allEvents, monthEvents) => [...monthEvents.reverse(), ...allEvents], [])
      .map((e) => e as ExpenseEvent.Event);

    const alreadyHappendEvents = {};
    pastExpenseEvents.forEach((e) => (alreadyHappendEvents[e.name] = true));

    let filtredExpenseEvents = ExpenseGeneratorConfig.allExpenses.filter(
      (e) => !alreadyHappendEvents[e.name]
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
