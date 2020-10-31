import * as uuid from 'uuid';
import * as random from 'random';

import { IncomeEvent } from './income_event';
import { Game, GameEntity } from '../../models/domain/game/game';
import { randomValueFromRange } from '../../core/data/value_range';

export namespace IncomeEventGenerator {
  export const generate = (
    game: Game,
    incomeEventInfo: IncomeEvent.Info[]
  ): IncomeEvent.Event | undefined => {
    const pastIncomeEvents = GameEntity.getPastEventsOfType<IncomeEvent.Event>({
      game,
      type: IncomeEvent.Type,
      maxHistoryLength: 12,
    });

    const alreadyHappenedEvents = {};
    pastIncomeEvents.forEach((e) => (alreadyHappenedEvents[e.name + e.description] = true));

    const filteredIncomeEvents = incomeEventInfo.filter(
      (e) => !alreadyHappenedEvents[e.name + e.description]
    );

    if (filteredIncomeEvents.length === 0) {
      return undefined;
    }

    const eventIndex = random.int(0, filteredIncomeEvents.length - 1);
    const eventInfo = filteredIncomeEvents[eventIndex];

    return generateEvent(eventInfo);
  };

  export const generateEvent = (eventInfo: IncomeEvent.Info): IncomeEvent.Event => {
    const income = randomValueFromRange(eventInfo.range);

    return {
      id: uuid.v4(),
      name: eventInfo.name,
      description: eventInfo.description,
      type: IncomeEvent.Type,
      data: {
        income,
      },
    };
  };
}
