import { Rule, RuleConfig } from '../generator_rule';
import { RealEstateBuyEvent } from '../../events/estate/buy/real_estate_buy_event';
import { Game } from '../../models/domain/game/game';
import { BuyRealEstateEventGenerator } from '../../events/estate/buy/real_estate_buy_event_generator';

export class RealEstateBuyRule extends Rule<RealEstateBuyEvent.Event> {
  constructor(private config: RuleConfig) {
    super();
  }

  getProbabilityLevel() {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return BuyRealEstateEventGenerator.generate(game);
  }

  getMinDistanceBetweenEvents() {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxHistoryLength() {
    return this.config.maxHistoryLength;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }

  getType() {
    return RealEstateBuyEvent.Type;
  }
}
