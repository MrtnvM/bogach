import { Game, GameEntity } from '../../../models/domain/game/game';
import { InsuranceAsset } from '../../../models/domain/assets/insurance_asset';
import { StockAsset } from '../../../models/domain/assets/stock_asset';
import { RealtyAsset } from '../../../models/domain/assets/realty_asset';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';
import { OtherAsset } from '../../../models/domain/assets/other_asset';
import { CashAsset } from '../../../models/domain/assets/cash_asset';
import { MortgageLiability } from '../../../models/domain/liabilities/mortgage_liability';
import { BusinessCreditLiability } from '../../../models/domain/liabilities/business_credit';
import { OtherLiability } from '../../../models/domain/liabilities/other_liability';
import { UserEntity } from '../../../models/domain/user';
import { Possessions } from '../../../models/domain/possessions';
import { PossessionStateEntity } from '../../../models/domain/possession_state';
import { GameContext } from '../../../models/domain/game/game_context';
import { GameEventEntity } from '../../../models/domain/game/game_event';
import { BusinessBuyEvent } from './business_buy_event_event';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const context: GameContext = { gameId, userId };
const initialCash = 100_000;

const create = <T>(obj: T) => obj;

const business1 = create<BusinessAsset>({
  id: 'business1',
  name: 'Химчистка',
  type: 'business',
  buyPrice: 120_000,
  downPayment: 21_000,
  fairPrice: 115_000,
  passiveIncomePerMonth: 2100,
  payback: 21,
  sellProbability: 7,
});

const initialPossesssions: Possessions = {
  incomes: [
    {
      id: 'income1',
      value: 92000,
      name: 'Зарплата',
      type: 'salary',
    },
    {
      id: 'income2',
      value: 1000,
      name: 'Карманные от бабушки',
      type: 'other',
    },
  ],
  expenses: [
    {
      id: 'expense1',
      name: 'Общее',
      value: 20000,
    },
  ],
  assets: [
    create<InsuranceAsset>({
      id: 'insurance1',
      name: 'Страховка квартиры',
      type: 'insurance',
      value: 50000,
      downPayment: 5000,
    }),
    business1,
    create<StockAsset>({
      id: 'stocks1',
      name: 'Яндекс',
      type: 'stock',
      averagePrice: 1000,
      countInPortfolio: 10,
      fairPrice: 900,
    }),
    create<RealtyAsset>({
      id: 'realty1',
      name: 'Квартира',
      type: 'realty',
      cost: 2000000,
      downPayment: 1000000,
    }),
    create<BusinessAsset>({
      id: 'business2',
      name: 'Птицеферма',
      type: 'business',
      buyPrice: 130_000,
      downPayment: 15_000,
      fairPrice: 135_000,
      passiveIncomePerMonth: 2500,
      payback: 22,
      sellProbability: 10,
    }),
    create<OtherAsset>({
      id: 'other_asset1',
      name: 'Биткойны',
      type: 'other',
      value: 30000,
      downPayment: 30000,
    }),
    create<CashAsset>({
      id: 'cash1',
      type: 'cash',
      value: 500,
      name: 'Наличные',
    }),
  ],
  liabilities: [
    create<MortgageLiability>({
      id: 'mortgage1',
      name: 'Ипотека',
      type: 'mortgage',
      value: 2000000,
      monthlyPayment: 20000,
    }),
    create<OtherLiability>({
      id: 'other_libility1',
      name: 'Долг другу',
      type: 'other',
      value: 5000,
      monthlyPayment: 500,
    }),
    create<BusinessCreditLiability>({
      id: 'business_credit1',
      value: 40000,
      name: 'Кредит за ларек',
      type: 'business_credit',
      monthlyPayment: 5000,
    }),
  ],
};

const game: Game = {
  id: gameId,
  name: 'Game 1',
  participants: [userId],
  possessions: {
    [userId]: initialPossesssions,
  },
  possessionState: {
    [userId]: PossessionStateEntity.createEmpty(),
  },
  accounts: {
    [userId]: { cashFlow: 10000, cash: initialCash, credit: 0 },
  },
  target: { type: 'cash', value: 1000000 },
  currentEvents: [],
};

const businessOfferEvent = (data: BusinessBuyEvent.Data) => {
  const event: BusinessBuyEvent.Event = {
    id: eventId,
    name: 'Торговая точка',
    description: 'Description',
    type: BusinessBuyEvent.Type,
    data: data,
  };

  BusinessBuyEvent.validate(event);
  return event;
};

const dryCleaningBusinessOfferEvent = (currentPrice: number) => {
  const eventData: BusinessBuyEvent.Data = {
    currentPrice: currentPrice,
    downPayment: 21_000,
    fairPrice: 115_000,
    passiveIncomePerMonth: 2100,
    payback: 21,
    debt: 99_000,
    sellProbability: 7,
  };

  const event: BusinessBuyEvent.Event = {
    id: eventId,
    name: 'Химчистка',
    description: 'Description',
    type: BusinessBuyEvent.Type,
    data: eventData,
  };

  BusinessBuyEvent.validate(event);
  return event;
};

const businessOfferEventPlayerAction = (action: BusinessBuyEvent.PlayerAction) => {
  BusinessBuyEvent.validateAction(action);
  return action;
};

export const stubs = {
  eventId,
  gameId,
  userId,
  context,
  game,
  business1,
  initialCash,
};

export const utils = {
  dryCleaningBusinessOfferEvent,
  businessOfferEvent,
  businessOfferEventPlayerAction,
};
