import { Game, GameEntity } from '../../models/domain/game/game';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { DebentureAsset } from '../../models/domain/assets/debenture_asset';
import { StockAsset } from '../../models/domain/assets/stock_asset';
import { RealtyAsset } from '../../models/domain/assets/realty_asset';
import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { OtherAsset } from '../../models/domain/assets/other_asset';
import { CashAsset } from '../../models/domain/assets/cash_asset';
import { MortgageLiability } from '../../models/domain/liabilities/mortgage_liability';
import { BusinessCreditLiability } from '../../models/domain/liabilities/business_credit';
import { OtherLiability } from '../../models/domain/liabilities/other_liability';
import { UserEntity } from '../../models/domain/user';
import { Possessions } from '../../models/domain/possessions';
import { PossessionStateEntity } from '../../models/domain/possession_state';
import { GameContext } from '../../models/domain/game/game_context';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { DebenturePriceChangedEvent } from './debenture_price_changed_event';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const context: GameContext = { gameId, userId };
const initialCash = 10000;

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
    debenture1,
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
      id: 'business1',
      name: 'Ларек с шавой',
      type: 'business',
      cost: 200000,
      downPayment: 100000,
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
  context,
  game,
  debenture1,
  initialCash,
};

export const utils = {
  debenturePriceChangedEvent,
  debenturePriceChangedPlayerAction,
  debentureOFZPriceChangedEvent,
};
