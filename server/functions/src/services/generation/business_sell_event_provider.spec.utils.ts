import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { GameEntity, Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';
import { RealtyAsset } from '../../models/domain/assets/realty_asset';
import { StockAsset } from '../../models/domain/assets/stock_asset';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { CashAsset } from '../../models/domain/assets/cash_asset';
import { OtherAsset } from '../../models/domain/assets/other_asset';
import { PossessionStateEntity } from '../../models/domain/possession_state';
import { Possessions } from '../../models/domain/possessions';
import { BusinessSellEvent } from '../../events/business/sell/business_sell_event';

const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 100_000;

const create = <T>(obj: T) => obj;

const businessSellEvent = create<BusinessSellEvent.Event>({
  id: 'id1',
  name: 'Предожение продать химчистку',
  type: 'business-sell-event',
  description: 'description',
  data: {
    businessId: '1',
    currentPrice: 100_000,
  },
});

const business1 = create<BusinessAsset>({
  id: 'id1',
  name: 'Химчистка',
  type: 'business',
  buyPrice: 120_000,
  downPayment: 21_000,
  fairPrice: 115_000,
  passiveIncomePerMonth: 2100,
  payback: 21,
  sellProbability: 100,
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
  sellProbability: 0,
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
  sellProbability: 100,
});

const initialPossesssions: Possessions = {
  incomes: [],
  expenses: [],
  assets: [
    create<InsuranceAsset>({
      id: 'insurance1',
      name: 'Страховка квартиры',
      type: 'insurance',
      value: 50000,
      cost: 5000,
      movesLeft: 12,
      insuranceType: 'health',
    }),
    business1,
    business2,
    business3,
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
      sellProbability: 0,
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
  liabilities: [],
};

const game: Game = {
  id: gameId,
  name: 'Game 1',
  type: 'singleplayer',
  participants: [userId],
  state: {
    gameStatus: 'players_move',
    monthNumber: 1,
    participantProgress: { [userId]: 0 },
    winners: {},
  },
  possessions: {
    [userId]: initialPossesssions,
  },
  possessionState: {
    [userId]: PossessionStateEntity.createEmpty(),
  },
  accounts: {
    [userId]: { cashFlow: 10_000, cash: initialCash, credit: 0 },
  },
  target: { type: 'cash', value: 1_000_000 },
  currentEvents: [],
};

export const stubs = {
  game,
  businessSellEvent,
};
