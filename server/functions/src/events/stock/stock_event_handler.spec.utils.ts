import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { Possessions } from '../../models/domain/possessions';
import { GameContext } from '../../models/domain/game/game_context';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { StockAsset } from '../../models/domain/assets/stock_asset';
import { StockEvent } from './stock_event';
import { GameFixture } from '../../core/fixtures/game_fixture';
import { ParticipantFixture } from '../../core/fixtures/participant_fixture';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const context: GameContext = { gameId, userId };
const initialCash = 10000;

const create = <T>(obj: T) => obj;

const stock1 = create<StockAsset>({
  id: 'stock1',
  name: 'Акции Сбербанка',
  type: 'stock',
  averagePrice: 110,
  countInPortfolio: 5,
  fairPrice: 100,
});

const initialPossessions: Possessions = {
  incomes: [],
  expenses: [],
  assets: [stock1],
  liabilities: [],
};

const game: Game = GameFixture.createGame({
  id: gameId,
  participants: {
    [userId]: ParticipantFixture.createParticipant({
      id: userId,
      possessions: initialPossessions,
      account: { cashFlow: 10000, cash: initialCash, credit: 0 },
    }),
  },
});

const stockPriceChangedEvent = (data: StockEvent.Data) => {
  const event: StockEvent.Event = {
    id: eventId,
    name: 'stockName',
    description: 'Description',
    type: StockEvent.Type,
    data: data,
  };

  StockEvent.validate(event);
  return event;
};

const stockSberbankPriceChangedEvent = (currentPrice: number, maxCount: number) => {
  const stockPriceEventData: StockEvent.Data = {
    currentPrice,
    fairPrice: 100,
    availableCount: maxCount,
    candles: [],
  };

  const event: StockEvent.Event = {
    id: eventId,
    name: 'Акции Сбербанка',
    description: 'Description',
    type: StockEvent.Type,
    data: stockPriceEventData,
  };

  StockEvent.validate(event);
  return event;
};

const stockPriceChangedPlayerAction = (action: StockEvent.PlayerAction) => {
  StockEvent.validateAction(action);
  return action;
};

export const stubs = {
  eventId,
  gameId,
  userId,
  context,
  game,
  stock1,
  initialCash,
};

export const utils = {
  stockSberbankPriceChangedEvent,
  stockPriceChangedEvent,
  stockPriceChangedPlayerAction,
};
