import { Game, GameEntity } from '../../models/domain/game/game';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { UserEntity } from '../../models/domain/user';
import { Possessions } from '../../models/domain/possessions';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { DebenturePriceChangedEvent } from './debenture_price_changed_event';
import { GameFixture } from '../../core/fixtures/game_fixture';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 10_000;

const create = <T>(obj: T) => obj;

const debenture1 = create<DebentureAsset>({
  id: 'debenture1',
  name: 'ОФЗ',
  type: 'debenture',
  count: 4,
  averagePrice: 1100,
  profitabilityPercent: 8,
  nominal: 1000,
});

const initialPossesssions: Possessions = {
  incomes: [],
  expenses: [],
  assets: [debenture1],
  liabilities: [],
};

const game: Game = GameFixture.createGame({
  id: gameId,
  participants: [userId],
  possessions: {
    [userId]: initialPossesssions,
  },
  accounts: {
    [userId]: { cashFlow: 10000, cash: initialCash, credit: 0 },
  },
});

const debenturePriceChangedEvent = (data: DebenturePriceChangedEvent.Data) => {
  const event: DebenturePriceChangedEvent.Event = {
    id: eventId,
    name: 'DebentureName',
    description: 'Description',
    type: DebenturePriceChangedEvent.Type,
    data: data,
  };

  DebenturePriceChangedEvent.validate(event);
  return event;
};

const debentureOFZPriceChangedEvent = (currentPrice: number, availableCount: number) => {
  const eventData: DebenturePriceChangedEvent.Data = {
    currentPrice,
    profitabilityPercent: 8,
    nominal: 1000,
    availableCount,
  };

  const event: DebenturePriceChangedEvent.Event = {
    id: eventId,
    name: 'ОФЗ',
    description: 'Description',
    type: DebenturePriceChangedEvent.Type,
    data: eventData,
  };

  DebenturePriceChangedEvent.validate(event);
  return event;
};

const debenturePriceChangedPlayerAction = (action: DebenturePriceChangedEvent.PlayerAction) => {
  DebenturePriceChangedEvent.validateAction(action);
  return action;
};

export const stubs = {
  eventId,
  gameId,
  userId,
  game,
  debenture1,
  initialCash,
};

export const utils = {
  debenturePriceChangedEvent,
  debenturePriceChangedPlayerAction,
  debentureOFZPriceChangedEvent,
};
