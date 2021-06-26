import { GameEntity, Game } from '../../models/domain/game/game';
import { User, UserEntity } from '../../models/domain/user/user';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { GameFixture } from '../../core/fixtures/game_fixture';
import { ParticipantFixture } from '../../core/fixtures/participant_fixture';
import { IncomeEvent } from '../../events/income/income_event';
import { ExpenseEvent } from '../../events/expense/expense_event';

export const gameId: GameEntity.Id = 'game1';
export const userId: UserEntity.Id = 'user1';

export const firstEventId: GameEventEntity.Id = 'event1';
export const lastEventId: GameEventEntity.Id = 'event2';

export const firstEventPlayerAction: IncomeEvent.PlayerAction = {};
export const lastEventPlayerAction: ExpenseEvent.PlayerAction = {};

const create = <T>(obj: T) => obj;

export const incomeEvent = create<IncomeEvent.Event>({
  id: firstEventId,
  name: 'Event 1 (Income)',
  description: 'Event 1 (Income)',
  type: IncomeEvent.Type,
  data: {
    income: 1_000,
  },
});

export const expenseEvent = create<ExpenseEvent.Event>({
  id: lastEventId,
  name: 'Event 2 (Expense)',
  description: 'Event 2 (Expense)',
  type: ExpenseEvent.Type,
  data: {
    expense: 1_000,
    insuranceType: 'health',
  },
});

export const game: Game = GameFixture.createGame({
  id: gameId,
  participantsIds: [userId],
  participants: {
    [userId]: ParticipantFixture.createParticipant({
      id: userId,
      possessions: {
        incomes: [
          {
            id: 'income1',
            value: 10_000,
            name: 'Зарплата',
            type: 'salary',
          },
        ],
        expenses: [],
        assets: [],
        liabilities: [],
      },
      possessionState: {
        incomes: [
          {
            id: 'income1',
            value: 10_000,
            name: 'Зарплата',
            type: 'salary',
          },
        ],
        expenses: [],
        assets: [],
        liabilities: [],
      },
      account: {
        cash: 20_000,
        cashFlow: 10_000,
        credit: 0,
      },
    }),
  },
  currentEvents: [incomeEvent, expenseEvent],
});

const getInitialProfile = (profile?: Partial<User>): User => {
  return {
    userId: profile?.userId || userId,
    userName: profile?.userName || 'John Dow',
    avatarUrl: profile?.avatarUrl || '',

    currentQuestIndex: profile?.currentQuestIndex,
    boughtQuestsAccess: profile?.boughtQuestsAccess,

    multiplayerGamePlayed: profile?.multiplayerGamePlayed || 0,
    purchaseProfile: profile?.purchaseProfile,

    playedGames: profile?.playedGames || {
      multiplayerGames: [],
    },
  };
};

export const TestData = {
  gameId,
  userId,
  game,
  firstEventId,
  firstEventPlayerAction,
  lastEventId,
  lastEventPlayerAction,
  getInitialProfile,
  incomeEvent,
  expenseEvent,
};
