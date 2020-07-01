import { BusinessAsset } from '../../models/domain/assets/business_asset';
import { GameEntity, Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { Possessions } from '../../models/domain/possessions';
import { BusinessSellEvent } from '../../events/business/sell/business_sell_event';
import { GameFixture } from '../../core/fixtures/game_fixture';

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
      duration: 12,
      fromMonth: 1,
      insuranceType: 'health',
    }),
    business1,
    business2,
    business3,
  ],
  liabilities: [],
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

export const stubs = {
  game,
  businessSellEvent,
};
