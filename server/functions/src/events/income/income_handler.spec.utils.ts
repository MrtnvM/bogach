import { Game, GameEntity } from '../../models/domain/game/game';
import { UserEntity } from '../../models/domain/user';
import { GameEventEntity } from '../../models/domain/game/game_event';
import { IncomeEvent } from './income_event';
import { GameFixture } from '../../core/fixtures/game_fixture';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const initialCash = 10_000;

const game: Game = GameFixture.createGame({
  id: gameId,
  participants: [userId],
  accounts: {
    [userId]: { cashFlow: 10000, cash: initialCash, credit: 0 },
  },
});

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
