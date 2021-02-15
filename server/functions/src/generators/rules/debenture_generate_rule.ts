import { Rule, RuleConfig } from '../generator_rule';
import { DebentureEvent } from '../../events/debenture/debenture_event';
import { DebentureEventGenerator } from '../../events/debenture/debenture_event_generator';
import { Game } from '../../models/domain/game/game';

export class DebentureGenerateRule extends Rule<DebentureEvent.Event> {
  constructor(private config: RuleConfig) {
    super();
  }

  getProbabilityLevel() {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return DebentureEventGenerator.generate(game);
  }

  getMinDistanceBetweenEvents() {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxHistoryLength() {
    return this.config.maxHistoryLength;
  }

  getType() {
    return DebentureEvent.Type;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }
}
