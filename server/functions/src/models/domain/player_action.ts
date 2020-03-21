import { GameEvent } from './game/game_event';
import { UserId } from './user';
import { GameEntity } from './game/game';

export interface PlayerAction<E = GameEvent, P = {}> {
  readonly gameEvent: E;
  readonly payload: P;
  readonly userId: UserId;
  readonly gameId: GameEntity.Id;
}
