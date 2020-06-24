import { Rule } from '../generator_rule';
import { BusinessBuyEvent } from '../../events/business/buy/business_buy_event';
import { BusinessBuyEventGenerator } from '../../events/business/buy/business_buy_event_generator';
import { Game } from '../../models/domain/game/game';

export class BusinessBuyGenerateRule extends Rule<BusinessBuyEvent.Event> {
  getProbabilityLevel(): number {
    return 10;
  }

  generate(game: Game) {
    return BusinessBuyEventGenerator.generate();
  }

  getMinDistanceBetweenEvents(): number {
    return 10;
  }

  getType(): string {
    return BusinessBuyEvent.Type;
  }
}
