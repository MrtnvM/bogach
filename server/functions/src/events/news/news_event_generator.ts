import * as uuid from 'uuid';
import * as random from 'random';

import { Game, GameEntity } from '../../models/domain/game/game';
import { NewsEvent } from './news_event';

export namespace NewsEventGenerator {
  export const generate = (
    game: Game,
    newsEventInfo: NewsEvent.Info[]
  ): NewsEvent.Event | undefined => {
    const pastNewsEvents = GameEntity.getPastEventsOfType<NewsEvent.Event>({
      game,
      type: NewsEvent.Type,
      maxHistoryLength: game.history?.months?.length ?? 12,
    });

    const alreadyHappenedEvents = {};
    pastNewsEvents.forEach((e) => (alreadyHappenedEvents[e.name + e.description] = true));

    const filteredNewsEvents = newsEventInfo.filter(
      (e) => !alreadyHappenedEvents[e.name + e.description]
    );

    if (filteredNewsEvents.length === 0) {
      return undefined;
    }

    const eventIndex = random.int(0, filteredNewsEvents.length - 1);
    const eventInfo = filteredNewsEvents[eventIndex];

    return generateEvent(eventInfo);
  };

  export const generateEvent = (eventInfo: NewsEvent.Info): NewsEvent.Event => {
    return {
      id: uuid.v4(),
      name: eventInfo.name,
      description: eventInfo.description,
      type: NewsEvent.Type,
      data: {
        imageUrl: eventInfo.imageUrl,
      },
    };
  };
}
