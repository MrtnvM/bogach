import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { Possessions } from '../../models/domain/possessions';
import { InsuranceEvent } from './insurance_event';
import { GameFixture } from '../../core/fixtures/game_fixture';

const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 10_000;

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
