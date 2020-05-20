import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';
import { PossessionsEntity } from '../../models/domain/possessions';
import { PossessionStateEntity } from '../../models/domain/possession_state';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { ExpenseEvent } from './expense_event';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 10_000;

const game: Game = {
  id: gameId,
  name: 'Game 1',
  type: 'singleplayer',
  participants: [userId],
  state: {
    gameStatus: 'players_move',
    monthNumber: 1,
    participantProgress: {
      [userId]: 0,
    },
    winners: {},
  },
  possessions: {
    [userId]: PossessionsEntity.createEmpty(),
  },
  possessionState: {
    [userId]: PossessionStateEntity.createEmpty(),
  },
  accounts: {
    [userId]: { cashFlow: 10000, cash: initialCash, credit: 0 },
  },
  target: { type: 'cash', value: 1000000 },
  currentEvents: [],
};

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
