import { Rule } from '../generator_rule';
import { DebenturePriceChangedEvent } from '../../events/debenture/debenture_price_changed_event';
import { DebenturePriceChangedEventGenerator } from '../../events/debenture/debenture_price_changed_event_generator';
import { Game } from '../../models/domain/game/game';

export class DebentureGenerateRule extends Rule<DebenturePriceChangedEvent.Event> {
  getProbabilityLevel(): number {
    return 10;
  }

  generate(game: Game) {
    return DebenturePriceChangedEventGenerator.generate(game);
  }

  getMinDistanceBetweenEvents(): number {
    return 0;
  }

  getType(): string {
    return DebenturePriceChangedEvent.Type;
  }

  getMaxCountOfEventInMonth() {
    return 1;
  }
}
