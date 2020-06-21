import { GameEvent } from '../models/domain/game/game_event';

export abstract class Rule<T> {
  canGenerate(events: GameEvent[]): boolean {
    return true;
  }
  abstract getPercentage(): number;
  abstract generate(events: GameEvent[]): T;
  abstract getMinDuration(): number;
  abstract getType(): string;
}
