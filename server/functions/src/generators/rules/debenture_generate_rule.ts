import { Rule } from '../generator_rule';
import { DebenturePriceChangedEvent } from '../../events/debenture/debenture_price_changed_event';
import { GameEvent } from '../../models/domain/game/game_event';
import { DebenturePriceChangedEventGenerator } from '../../events/debenture/debenture_price_changed_event_generator';

export class DebentureRule extends Rule<DebenturePriceChangedEvent.Event> {
  canGenerate(events: GameEvent[]): boolean {
    return true;
  }
  
  getPercentage(): number {
    return 10;
  }

  generate() {
    return DebenturePriceChangedEventGenerator.generate();
  }

  getMinDuration(): number {
    return 4;
  }

  getType(): string {
    return DebenturePriceChangedEvent.Type;
  }
}
