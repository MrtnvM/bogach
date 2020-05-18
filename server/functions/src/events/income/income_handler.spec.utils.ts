import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';
import { PossessionsEntity } from '../../models/domain/possessions';
import { PossessionStateEntity } from '../../models/domain/possession_state';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { IncomeEvent } from './income_event';

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

const incomeEvent = (data: IncomeEvent.Data) => {
  const event: IncomeEvent.Event = {
    id: eventId,
    name: 'IncomeName',
    description: 'Description',
    type: IncomeEvent.Type,
    data: data,
  };

  IncomeEvent.validate(event);
  return event;
};

const incomePlayerAction = (action: IncomeEvent.PlayerAction) => {
  IncomeEvent.validateAction(action);
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
    incomeEvent,
    incomePlayerAction,
};
