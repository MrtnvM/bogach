import { GameEvent } from '../models/domain/game/game_event';

export abstract class Rule<T> {
  abstract canGenerate(events: GameEvent[]): boolean;
  abstract getPercentage(): number;
  abstract generate(): T;
  abstract getMinDuration(): number;
  abstract getType(): string;
}
