import { GameEvent } from '../models/domain/game/game_event';
import { Game } from '../models/domain/game/game';

export type RuleConfig = {
  readonly probabilityLevel: number;
  readonly minDistanceBetweenEvents: number;
  readonly maxCountOfEventInMonth?: number;
};

export abstract class Rule<T extends GameEvent = GameEvent> {
  abstract getProbabilityLevel(): number;
  abstract generate(game: Game): T | undefined;
  abstract getMinDistanceBetweenEvents(): number;
  abstract getType(): string;

  getMaxCountOfEventInMonth(): number {
    return 0;
  }
}
