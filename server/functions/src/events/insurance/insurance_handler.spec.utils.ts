import { Game, GameEntity } from '../../models/domain/game/game';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
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
import { InsuranceEvent } from './insurance_event';
import { GameFixture } from '../../core/fixtures/game_fixture';

const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 10_000;

const create = <T>(obj: T) => obj;

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
      insuranceType: 'health',
      value: 50000,
      duration: 12,
      fromMonth: 1,
      cost: 5000,
    }),
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
      fairPrice: 200000,
      downPayment: 100000,
      buyPrice: 210_000,
      payback: 20,
      passiveIncomePerMonth: 2000,
      sellProbability: 5,
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

const insuranceChangedEvent = (data: InsuranceEvent.Data, eventId: string) => {
  const event: InsuranceEvent.Event = {
    id: eventId,
    name: 'СЖ',
    description: 'Description',
    type: InsuranceEvent.Type,
    data: data,
  };

  InsuranceEvent.validate(event);
  return event;
};

export const stubs = {
  gameId,
  userId,
  game,
  initialCash,
};

export const utils = {
  insuranceChangedEvent,
};
