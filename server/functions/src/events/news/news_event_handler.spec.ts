/// <reference types="@types/jest"/>

import { GameEntity } from '../../models/domain/game/game';
import { stubs, utils } from './news_event_handler.spec.utils';
import { NewsEventHandler } from './news_event_handler';
import { NewsEvent } from './news_event';

describe('News event handler', () => {
  const { userId, game } = stubs;

  beforeEach(() => {
    GameEntity.validate(game);
  });

  test('Successfully get news', async () => {
    const handler = new NewsEventHandler();

    const event = utils.newsEvent({
      imageUrl: 'https://google.com',
    });

    const action = utils.newsPlayerAction({
      eventId: utils.eventId,
    });

    const newGame = await handler.handle(game, event, action, userId);

    expect(newGame.history.months.pop()?.events.pop()?.type == NewsEvent.Type);
  });
});
