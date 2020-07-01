import { Game, GameEntity } from '../../../models/domain/game/game';
import { UserEntity } from '../../../models/domain/user';
import { Possessions } from '../../../models/domain/possessions';
import { GameEventEntity } from '../../../models/domain/game/game_event';
import { MonthlyExpenseEvent } from '../monthly_expense_event';
import { GameFixture } from '../../../core/fixtures/game_fixture';

const eventId: GameEventEntity.Id = 'event1';
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

const monthlyExpenseEvent = (data: MonthlyExpenseEvent.Data) => {
  const event: MonthlyExpenseEvent.Event = {
    id: eventId,
    name: 'Name',
    description: 'Description',
    type: MonthlyExpenseEvent.Type,
    data: data,
  };

  MonthlyExpenseEvent.validate(event);
  return event;
};

export const stubs = {
  eventId,
  gameId,
  userId,
  game,
  initialCash,
};

export const utils = {
  monthlyExpenseEvent,
};
