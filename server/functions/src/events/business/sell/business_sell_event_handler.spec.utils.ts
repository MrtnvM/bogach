import { Game, GameEntity } from '../../../models/domain/game/game';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';
import { BusinessCreditLiability } from '../../../models/domain/liabilities/business_credit';
import { UserEntity } from '../../../models/domain/user';
import { Possessions } from '../../../models/domain/possessions';
import { GameContext } from '../../../models/domain/game/game_context';
import { GameEventEntity } from '../../../models/domain/game/game_event';
import { BusinessSellEvent } from './business_sell_event';
import { GameFixture } from '../../../core/fixtures/game_fixture';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const context: GameContext = { gameId, userId };
const initialCash = 100_000;

const create = <T>(obj: T) => obj;

const business1 = create<BusinessAsset>({
  id: 'id1',
  name: 'Химчистка',
  type: 'business',
  buyPrice: 120_000,
  downPayment: 21_000,
  fairPrice: 115_000,
  passiveIncomePerMonth: 2100,
  payback: 21,
  sellProbability: 7,
});

const business2 = create<BusinessAsset>({
  id: 'id2',
  name: 'Автомойка',
  type: 'business',
  buyPrice: 150_000,
  downPayment: 30_000,
  fairPrice: 120_000,
  passiveIncomePerMonth: 2100,
  payback: 21,
  sellProbability: 7,
});

const business3 = create<BusinessAsset>({
  id: 'id3',
  name: 'Бизнес без займа',
  type: 'business',
  buyPrice: 150_000,
  downPayment: 30_000,
  fairPrice: 120_000,
  passiveIncomePerMonth: 2100,
  payback: 21,
  sellProbability: 7,
});

const initialPossesssions: Possessions = {
  incomes: [],
  expenses: [],
  assets: [business1, business2, business3],
  liabilities: [
    create<BusinessCreditLiability>({
      id: 'id1',
      value: 99_000,
      name: 'Химчистка',
      type: 'business_credit',
      monthlyPayment: 0,
    }),
    create<BusinessCreditLiability>({
      id: 'id2',
      value: 120_000,
      name: 'Автомойка',
      type: 'business_credit',
      monthlyPayment: 0,
    }),
  ],
};

const game: Game = GameFixture.createGame({
  id: gameId,
  participants: [userId],
  possessions: {
    [userId]: initialPossesssions,
  },
  accounts: {
    [userId]: { cashFlow: 10_000, cash: initialCash, credit: 0 },
  },
});

const businessOfferEvent = (data: BusinessSellEvent.Data) => {
  const event: BusinessSellEvent.Event = {
    id: eventId,
    name: 'Торговая точка',
    description: 'Description',
    type: BusinessSellEvent.Type,
    data: data,
  };

  BusinessSellEvent.validate(event);
  return event;
};

const dryCleaningBusinessOfferEvent = (currentPrice: number) => {
  const eventData: BusinessSellEvent.Data = {
    businessId: 'id1',
    currentPrice: currentPrice,
  };

  const event: BusinessSellEvent.Event = {
    id: eventId,
    name: 'Химчистка',
    description: 'Description',
    type: BusinessSellEvent.Type,
    data: eventData,
  };

  BusinessSellEvent.validate(event);
  return event;
};

const carwashingBusinessSellEvent = (currentPrice: number) => {
  const eventData: BusinessSellEvent.Data = {
    businessId: 'id2',
    currentPrice: currentPrice,
  };

  const event: BusinessSellEvent.Event = {
    id: eventId,
    name: 'Автомойка',
    description: 'Description',
    type: BusinessSellEvent.Type,
    data: eventData,
  };

  BusinessSellEvent.validate(event);
  return event;
};

const businessOfferEventPlayerAction = (action: BusinessSellEvent.PlayerAction) => {
  BusinessSellEvent.validateAction(action);
  return action;
};

export const stubs = {
  eventId,
  gameId,
  userId,
  context,
  game,
  initialCash,
};

export const utils = {
  dryCleaningBusinessOfferEvent,
  carwashingBusinessSellEvent,
  businessOfferEvent,
  businessOfferEventPlayerAction,
};
