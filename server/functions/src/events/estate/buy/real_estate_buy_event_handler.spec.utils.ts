import { Game, GameEntity } from '../../../models/domain/game/game';
import { RealtyAsset } from '../../../models/domain/assets/realty_asset';
import { UserEntity } from '../../../models/domain/user';
import { Possessions } from '../../../models/domain/possessions';
import { GameEventEntity } from '../../../models/domain/game/game_event';
import { GameFixture } from '../../../core/fixtures/game_fixture';
import { RealEstateBuyEvent } from './real_estate_buy_event';
import { Liability } from '../../../models/domain/liability';

const create = <T>(obj: T) => obj;

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 100_000;

const initialPossesions: Possessions = {
  assets: [
    create<RealtyAsset>({
      id: 'existingRealtyAssetId',
      name: 'Гараж',
      type: 'realty',
      buyPrice: 100_000,
      downPayment: 15_000,
      fairPrice: 90_000,
      passiveIncomePerMonth: 2100,
      payback: 40,
      sellProbability: 7,
    }),
  ],
  incomes: [],
  liabilities: [
    create<Liability>({
      id: 'existingRealtyLiabilityId',
      type: 'real_estate_credit',
      name: 'Гараж',
      monthlyPayment: 0,
      value: 80_000,
    }),
  ],
  expenses: [],
};

const game: Game = GameFixture.createGame({
  id: gameId,
  participants: [userId],
  possessions: {
    [userId]: initialPossesions,
  },
  accounts: {
    [userId]: { cashFlow: 10000, cash: initialCash, credit: 0 },
  },
});

export const stubs = {
  eventId,
  gameId,
  userId,
  initialCash,
  game,
};

const createBuyRealEstateEvent = (data: RealEstateBuyEvent.Data) => {
  const event: RealEstateBuyEvent.Event = {
    id: eventId,
    name: 'Купить недвижимость',
    description: '',
    type: RealEstateBuyEvent.Type,
    data: data,
  };

  RealEstateBuyEvent.validate(event);

  return event;
};

const createBuyRealEstateAction = (actionEventId: GameEventEntity.Id) => {
  const action: BuyRealEstateEvent.PlayerAction = {
    eventId: actionEventId,
  };

  return action;
};

export const utils = {
  createBuyRealEstateEvent,
  createBuyRealEstateAction,
};
