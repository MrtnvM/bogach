import { Game, GameEntity } from '../../models/domain/game/game';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { UserEntity } from '../../models/domain/user/user';
import { Possessions } from '../../models/domain/possessions';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { DebentureEvent } from './debenture_event';
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

const debentureEvent = (data: DebentureEvent.Data) => {
  const event: DebentureEvent.Event = {
    id: eventId,
    name: 'DebentureName',
    description: 'Description',
    type: DebentureEvent.Type,
    data: data,
  };

  DebentureEvent.validate(event);
  return event;
};

const debentureOFZEvent = (currentPrice: number, availableCount: number) => {
  const eventData: DebentureEvent.Data = {
    currentPrice,
    profitabilityPercent: 8,
    nominal: 1000,
    availableCount,
  };

  const event: DebentureEvent.Event = {
    id: eventId,
    name: 'ОФЗ',
    description: 'Description',
    type: DebentureEvent.Type,
    data: eventData,
  };

  DebentureEvent.validate(event);
  return event;
};

const debenturePlayerAction = (action: DebentureEvent.PlayerAction) => {
  DebentureEvent.validateAction(action);
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
  debentureEvent,
  debenturePlayerAction,
  debentureOFZEvent,
};
