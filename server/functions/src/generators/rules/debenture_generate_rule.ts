import { Rule } from '../generator_rule';
import { DebentureEvent } from '../../events/debenture/debenture_event';
import { DebentureEventGenerator } from '../../events/debenture/debenture_event_generator';
import { Game } from '../../models/domain/game/game';

export class DebentureGenerateRule extends Rule<DebentureEvent.Event> {
  getProbabilityLevel(): number {
    return 10;
  }

  generate(game: Game) {
    return DebentureEventGenerator.generate(game);
  }

  getMinDistanceBetweenEvents(): number {
    return 0;
  }

  getType(): string {
    return DebentureEvent.Type;
  }

  getMaxCountOfEventInMonth() {
    return 1;
  }
}
