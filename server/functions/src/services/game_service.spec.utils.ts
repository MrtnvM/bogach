import { GameEntity, Game } from '../models/domain/game/game';
import { UserEntity } from '../models/domain/user';
import { PossessionStateEntity } from '../models/domain/possession_state';
import { PossessionsEntity } from '../models/domain/possessions';
import { DebenturePriceChangedEvent } from '../events/debenture/debenture_price_changed_event';
import { GameEventEntity } from '../models/domain/game/game_event';

export const gameId: GameEntity.Id = 'game1';
export const userId: UserEntity.Id = 'user1';

export const firstEventId: GameEventEntity.Id = 'event1';
export const lastEventId: GameEventEntity.Id = 'event2';

export const firstEventPlayerAction: DebenturePriceChangedEvent.PlayerAction = {
  eventId: firstEventId,
  action: 'buy',
  count: 1,
};

export const lastEventPlayerAction: DebenturePriceChangedEvent.PlayerAction = {
  eventId: lastEventId,
  action: 'buy',
  count: 1,
};

const create = <T>(obj: T) => obj;

export const game: Game = {
  id: gameId,
  name: 'Game 1',
  type: 'singleplayer',
  participants: [userId],
  state: {
    gameState: 'players_move',
    monthNumber: 1,
    participantProgress: { [userId]: 0 },
    winners: {},
  },
  possessions: { [userId]: PossessionsEntity.createEmpty() },
  possessionState: {
    [userId]: PossessionStateEntity.createEmpty(),
  },
  accounts: {
    [userId]: {
      cash: 20_000,
      cashFlow: 10_000,
      credit: 0,
    },
  },
  target: { type: 'cash', value: 1000000 },
  currentEvents: [
    create<DebenturePriceChangedEvent.Event>({
      id: firstEventId,
      name: 'Debenture Event 1',
      description: 'Debenture Event 1',
      type: DebenturePriceChangedEvent.Type,
      data: {
        currentPrice: 1_100,
        nominal: 1_000,
        profitabilityPercent: 8,
        availableCount: 100,
      },
    }),
    create<DebenturePriceChangedEvent.Event>({
      id: lastEventId,
      name: 'Debenture Event 2',
      description: 'Debenture Event 2',
      type: DebenturePriceChangedEvent.Type,
      data: {
        currentPrice: 900,
        nominal: 1_000,
        profitabilityPercent: 6,
        availableCount: 100,
      },
    }),
  ],
};

export const TestData = {
  gameId,
  userId,
  game,
  firstEventId,
  firstEventPlayerAction,
  lastEventId,
  lastEventPlayerAction,
};
