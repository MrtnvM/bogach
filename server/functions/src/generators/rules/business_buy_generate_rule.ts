import { Rule, RuleConfig } from '../generator_rule';
import { BusinessBuyEvent } from '../../events/business/buy/business_buy_event';
import { BusinessBuyEventGenerator } from '../../events/business/buy/business_buy_event_generator';
import { Game } from '../../models/domain/game/game';

export class BusinessBuyGenerateRule extends Rule<BusinessBuyEvent.Event> {
  constructor(private config: RuleConfig) {
    super();
  }

  getProbabilityLevel(): number {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return BusinessBuyEventGenerator.generate();
  }

  getMinDistanceBetweenEvents() {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxHistoryLength() {
    return this.config.maxHistoryLength;
  }

  getType(): string {
    return BusinessBuyEvent.Type;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }
}
