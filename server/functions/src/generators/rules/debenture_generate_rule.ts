import { Rule } from '../generator_rule';
import { DebenturePriceChangedEvent } from '../../events/debenture/debenture_price_changed_event';
import { DebenturePriceChangedEventGenerator } from '../../events/debenture/debenture_price_changed_event_generator';
import { GameEvent } from '../../models/domain/game/game_event';

export class DebentureGenerateRule extends Rule<DebenturePriceChangedEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate(events: GameEvent[]) {
    return DebenturePriceChangedEventGenerator.generate();
  }

  getMinDuration(): number {
    return 1;
  }

  getType(): string {
    return DebenturePriceChangedEvent.Type;
  }
}
