import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { GameFixture } from '../../core/fixtures/game_fixture';
import { ParticipantFixture } from '../../core/fixtures/participant_fixture';
import { NewsEvent } from './news_event';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 10_000;

const game: Game = GameFixture.createGame({
  id: gameId,
  participants: {
    [userId]: ParticipantFixture.createParticipant({
      id: userId,
      account: { cashFlow: 10000, cash: initialCash, credit: 0 },
    }),
  },
});

const newsEvent = (data: NewsEvent.Data) => {
  const event: NewsEvent.Event = {
    id: eventId,
    name: 'NewsName',
    description: 'Description',
    type: NewsEvent.Type,
    data: data,
  };

  NewsEvent.validate(event);
  return event;
};

const newsPlayerAction = (action: NewsEvent.PlayerAction) => {
  NewsEvent.validateAction(action);
  return action;
};

export const stubs = {
  eventId,
  gameId,
  userId,
  game,
  initialCash,
};

export const utils = {
  newsEvent,
  newsPlayerAction,
  eventId,
};
