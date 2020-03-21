import { GameEvent } from './game_event';
import { UserId } from './user';
import { GameId } from './game';

export interface PlayerAction<E = GameEvent, P = {}> {
  readonly gameEvent: E;
  readonly payload: P;
  readonly userId: UserId;
  readonly gameId: GameId;
}
