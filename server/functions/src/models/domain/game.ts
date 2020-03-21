import { GameEvent } from './game_event';

export type GameId = string;

export interface Game {
  readonly id: GameId;
  readonly currentEvents: GameEvent[];
  readonly createdAt?: Date;
  readonly updatedAt?: Date;
}
