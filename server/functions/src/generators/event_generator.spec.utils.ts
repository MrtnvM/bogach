import { Game, GameEntity } from '../models/domain/game/game';
import { GameFixture } from '../core/fixtures/game_fixture';
import { GameContext } from '../models/domain/game/game_context';
import { UserEntity } from '../models/domain/user';
import { GameEventEntity } from '../models/domain/game/game_event';
import { Possessions } from '../models/domain/possessions';

const eventId: GameEventEntity.Id = 'event1';
const gameId: GameEntity.Id = 'game1';
const userId: UserEntity.Id = 'user1';
const context: GameContext = { gameId, userId };
const initialCash = 10000;

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

export const stubs = {
  eventId,
  gameId,
  userId,
  context,
  game,
  initialCash,
};
