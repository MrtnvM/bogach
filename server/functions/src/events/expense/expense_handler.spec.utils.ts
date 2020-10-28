import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user/user';
import { Possessions } from '../../models/domain/possessions';
import { InsuranceAsset } from '../../models/domain/assets/insurance_asset';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { ExpenseEvent } from './expense_event';
import { GameFixture } from '../../core/fixtures/game_fixture';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 10_000;

const create = <T>(obj: T) => obj;

const initialPossessions: Possessions = {
  assets: [
    create<InsuranceAsset>({
      id: 'insurance1',
      name: 'Страховка квартиры',
      type: 'insurance',
      value: 5_000,
      cost: 6_000,
      duration: 12,
      fromMonth: 1,
      insuranceType: 'property',
    }),
  ],
  incomes: [],
  liabilities: [],
  expenses: [],
};

const game: Game = GameFixture.createGame({
  id: gameId,
  participants: [userId],
  possessions: {
    [userId]: initialPossessions,
  },
  accounts: {
    [userId]: { cashFlow: 10000, cash: initialCash, credit: 0 },
  },
});

const expenseEvent = (data: ExpenseEvent.Data) => {
  const event: ExpenseEvent.Event = {
    id: eventId,
    name: 'ExpenseName',
    description: 'Description',
    type: ExpenseEvent.Type,
    data: data,
  };

  ExpenseEvent.validate(event);
  return event;
};

const expensePlayerAction = (action: ExpenseEvent.PlayerAction) => {
  ExpenseEvent.validateAction(action);
  return action;
};

export const stubs = {
  eventId,
  gameId,
  userId,
  game,
  initialCash,
};

export const utils = {
  expenseEvent,
  expensePlayerAction,
};
