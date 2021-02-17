import { GameEvent } from '../models/domain/game/game_event';
import { Game } from '../models/domain/game/game';

export type RuleConfig = {
  readonly probabilityLevel: number;
  readonly minDistanceBetweenEvents: number;
  readonly maxCountOfEventInMonth: number;
  readonly maxHistoryLength: number;
};

export abstract class Rule<T extends GameEvent = GameEvent> {
  abstract getType(): string;

  abstract generate(game: Game): T | undefined;

  abstract getProbabilityLevel(): number;
  abstract getMinDistanceBetweenEvents(): number;
  abstract getMaxCountOfEventInMonth(): number;

  /// If returns positive number - it's a number of months that should be saved
  /// If returns negative - it's a number of events that should be saved
  abstract getMaxHistoryLength(): number;
}
