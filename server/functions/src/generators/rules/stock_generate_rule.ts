import { Rule, RuleConfig } from '../generator_rule';
import { StockEvent } from '../../events/stock/stock_event';
import { StockEventGenerator } from '../../events/stock/stock_event_generator';
import { Game } from '../../models/domain/game/game';

export class StockGenerateRule extends Rule<StockEvent.Event> {
  constructor(private config: RuleConfig) {
    super();
  }

  getProbabilityLevel() {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return StockEventGenerator.generate(game);
  }

  getMinDistanceBetweenEvents() {
    return this.config.minDistanceBetweenEvents;
  }

  getType() {
    return StockEvent.Type;
  }

  getMaxHistoryLength() {
    return this.config.maxHistoryLength;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }
}
