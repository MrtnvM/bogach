import { Rule } from '../generator_rule';
import { DebenturePriceChangedEvent } from '../../events/debenture/debenture_price_changed_event';
import { DebenturePriceChangedEventGenerator } from '../../events/debenture/debenture_price_changed_event_generator';

export class DebentureGenerateRule extends Rule<DebenturePriceChangedEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate() {
    return DebenturePriceChangedEventGenerator.generate();
  }

  getMinDuration(): number {
    return 1;
  }

  getType(): string {
    return DebenturePriceChangedEvent.Type;
  }
}
