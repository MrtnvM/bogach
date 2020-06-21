import { Rule } from '../generator_rule';
import { BusinessBuyEvent } from '../../events/business/buy/business_buy_event';
import { BusinessBuyEventGenerator } from '../../events/business/buy/business_buy_event_generator';
import { GameEvent } from '../../models/domain/game/game_event';

export class BusinessBuyGenerateRule extends Rule<BusinessBuyEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate(events: GameEvent[]) {
    return BusinessBuyEventGenerator.generate();
  }

  getMinDuration(): number {
    return 10;
  }

  getType(): string {
    return BusinessBuyEvent.Type;
  }
}
