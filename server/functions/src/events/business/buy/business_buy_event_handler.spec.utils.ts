import { Game, GameEntity } from '../../../models/domain/game/game';
import { BusinessAsset } from '../../../models/domain/assets/business_asset';
import { BusinessCreditLiability } from '../../../models/domain/liabilities/business_credit';
import { UserEntity } from '../../../models/domain/user/user';
import { Possessions } from '../../../models/domain/possessions';
import { GameContext } from '../../../models/domain/game/game_context';
import { GameEventEntity } from '../../../models/domain/game/game_event';
import { BusinessBuyEvent } from './business_buy_event';
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

const initialPossesssions: Possessions = {
  incomes: [],
  expenses: [],
  assets: [
    business1,
  ],
  liabilities: [
    create<BusinessCreditLiability>({
      id: 'existingLiabilityId',
      value: 20_000,
      name: 'Химчистка',
      type: 'business_credit',
      monthlyPayment: 0,
    }),
    create<BusinessCreditLiability>({
      id: 'business_credit2',
      value: 10_000,
      name: 'Бизнес у которого совпадет долг',
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
    businessId: 'id1',
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
  initialCash,
};

export const utils = {
  dryCleaningBusinessOfferEvent,
  businessOfferEvent,
  businessOfferEventPlayerAction,
};
