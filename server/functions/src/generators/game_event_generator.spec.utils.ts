import { Game, GameEntity } from '../models/domain/game/game';
import { GameFixture } from '../core/fixtures/game_fixture';
import { GameContext } from '../models/domain/game/game_context';
import { UserEntity } from '../models/domain/user';
import { GameEventEntity } from '../models/domain/game/game_event';
import { Possessions } from '../models/domain/possessions';
import { instance, when, mock, anything } from 'ts-mockito';
import { DebentureEvent } from '../events/debenture/debenture_event';
import { DebentureGenerateRule } from './rules/debenture_generate_rule';
import { StockPriceChangedEvent } from '../events/stock/stock_price_changed_event';
import { StockGenerateRule } from './rules/stock_generate_rule';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const context: GameContext = { gameId, userId };
const initialCash = 10000;

const initialPossesssions: Possessions = {
  incomes: [],
  expenses: [],
  assets: [],
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

export const stubs = {
  eventId,
  gameId,
  userId,
  context,
  game,
  initialCash,
};

export const debentureEvent = () => {
  return {
    id: 'event1',
    name: 'ОФЗ',
    description: 'ОФЗ',
    type: DebentureEvent.Type,
    data: {
      currentPrice: 1100,
      nominal: 1000,
      profitabilityPercent: 6.5,
      availableCount: 100,
    },
  };
};

export const createMockedDebentureRule = (config: {
  minDistance?: number;
  maxEventsInMonth?: number;
  probabilityLevel?: number[];
  events?: DebentureEvent.Event[];
}) => {
  const mockDebentureRule = mock(DebentureGenerateRule);

  when(mockDebentureRule.getMinDistanceBetweenEvents()).thenReturn(config.minDistance || 0);
  when(mockDebentureRule.getProbabilityLevel()).thenReturn(...(config.probabilityLevel || [10]));
  when(mockDebentureRule.getType()).thenReturn(DebentureEvent.Type);
  when(mockDebentureRule.getMaxCountOfEventInMonth()).thenReturn(config.maxEventsInMonth || 0);

  const event = {
    id: 'event1',
    name: 'ОФЗ',
    description: 'ОФЗ',
    type: DebentureEvent.Type,
    data: {
      currentPrice: 1100,
      nominal: 1000,
      profitabilityPercent: 6.5,
      availableCount: 100,
    },
  };

  when(mockDebentureRule.generate(anything())).thenReturn(...(config.events || [event]));

  const debentureRule = instance(mockDebentureRule);
  return debentureRule;
};

export const createMockedStockRule = (config: {
  minDistance?: number;
  maxEventsInMonth?: number;
  probabilityLevel?: number[];
  events?: StockPriceChangedEvent.Event[];
}) => {
  const mockStockRule = mock(StockGenerateRule);

  when(mockStockRule.getMinDistanceBetweenEvents()).thenReturn(config.minDistance || 0);
  when(mockStockRule.getProbabilityLevel()).thenReturn(...(config.probabilityLevel || [10]));
  when(mockStockRule.getType()).thenReturn(StockPriceChangedEvent.Type);
  when(mockStockRule.getMaxCountOfEventInMonth()).thenReturn(config.maxEventsInMonth || 0);

  const event: StockPriceChangedEvent.Event = {
    id: 'event2',
    name: 'Yandex',
    description: 'Yandex',
    type: StockPriceChangedEvent.Type,
    data: {
      currentPrice: 3100,
      fairPrice: 2900,
      availableCount: 100,
    },
  };

  when(mockStockRule.generate(anything())).thenReturn(...(config.events || [event]));

  const stockRule = instance(mockStockRule);
  return stockRule;
};
