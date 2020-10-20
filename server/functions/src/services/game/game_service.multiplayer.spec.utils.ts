import { GameEntity, Game } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';
import { DebentureEvent } from '../../events/debenture/debenture_event';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { GameFixture } from '../../core/fixtures/game_fixture';
import produce from 'immer';

export const gameId: GameEntity.Id = 'game1';
export const user1: UserEntity.Id = 'user1';
export const user2: UserEntity.Id = 'user2';
export const participantIds = [user1, user2];

export const firstEventId: GameEventEntity.Id = 'event1';
export const lastEventId: GameEventEntity.Id = 'event2';

export const firstEventPlayerAction: DebentureEvent.PlayerAction = {
  eventId: firstEventId,
  action: 'buy',
  count: 1,
};

export const lastEventPlayerAction: DebentureEvent.PlayerAction = {
  eventId: lastEventId,
  action: 'buy',
  count: 1,
};

const create = <T>(obj: T) => obj;

export const game: Game = GameFixture.createGame({
  id: gameId,
  type: 'multiplayer',
  participants: participantIds,
  possessions: {
    [user1]: {
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

    [user2]: {
      incomes: [
        {
          id: 'income2',
          value: 20_000,
          name: 'Зарплата',
          type: 'salary',
        },
      ],
      expenses: [],
      assets: [],
      liabilities: [],
    },
  },
  possessionState: {
    [user1]: {
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
    [user2]: {
      incomes: [
        {
          id: 'income2',
          value: 20_000,
          name: 'Зарплата',
          type: 'salary',
        },
      ],
      expenses: [],
      assets: [],
      liabilities: [],
    },
  },
  accounts: {
    [user1]: {
      cash: 20_000,
      cashFlow: 10_000,
      credit: 0,
    },
    [user2]: {
      cash: 20_000,
      cashFlow: 10_000,
      credit: 0,
    },
  },
  currentEvents: [
    create<DebentureEvent.Event>({
      id: firstEventId,
      name: 'Debenture Event 1',
      description: 'Debenture Event 1',
      type: DebentureEvent.Type,
      data: {
        currentPrice: 1_100,
        nominal: 1_000,
        profitabilityPercent: 8,
        availableCount: 100,
      },
    }),
    create<DebentureEvent.Event>({
      id: lastEventId,
      name: 'Debenture Event 2',
      description: 'Debenture Event 2',
      type: DebentureEvent.Type,
      data: {
        currentPrice: 900,
        nominal: 1_000,
        profitabilityPercent: 6,
        availableCount: 100,
      },
    }),
  ],
});

const gameWithNotCompletedMonthForFirstPlayer = produce(game, (draft) => {
  draft.state.participantsProgress = {
    [user1]: produce(game.state.participantsProgress[user1], (draft1) => {
      draft1.currentEventIndex = 0;
      draft1.status = 'player_move';
    }),
    [user2]: produce(game.state.participantsProgress[user2], (draft2) => {
      draft2.currentEventIndex = 1;
      draft2.status = 'month_result';
    }),
  };
});

const gameWhenOnlyFirstPlayerStartedNewMonth = produce(game, (draft) => {
  draft.state.monthNumber = 2;

  draft.state.participantsProgress = {
    [user1]: produce(game.state.participantsProgress[user1], (draft1) => {
      draft1.currentEventIndex = 0;
      draft1.currentMonthForParticipant = 2;
      draft1.status = 'player_move';
    }),
    [user2]: produce(game.state.participantsProgress[user2], (draft2) => {
      draft2.currentMonthForParticipant = 1;
      draft2.currentEventIndex = 1;
      draft2.status = 'month_result';
    }),
  };
});

const gameWithNotStartedMonthByParticipants = produce(game, (draft) => {
  draft.state.monthNumber = 2;

  draft.state.participantsProgress = {
    [user1]: produce(game.state.participantsProgress[user1], (draft1) => {
      draft1.currentEventIndex = 1;
      draft1.currentMonthForParticipant = 1;
      draft1.status = 'month_result';
    }),
    [user2]: produce(game.state.participantsProgress[user2], (draft2) => {
      draft2.currentMonthForParticipant = 1;
      draft2.currentEventIndex = 1;
      draft2.status = 'month_result';
    }),
  };
});

export const TestData = {
  gameId,
  user1,
  user2,
  participantIds,
  game,
  gameWithNotCompletedMonthForFirstPlayer,
  gameWhenOnlyFirstPlayerStartedNewMonth,
  gameWithNotStartedMonthByParticipants,
  firstEventId,
  firstEventPlayerAction,
  lastEventId,
  lastEventPlayerAction,
};
