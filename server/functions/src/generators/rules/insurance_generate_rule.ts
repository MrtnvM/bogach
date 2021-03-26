import { Rule, RuleConfig } from '../generator_rule';
import { InsuranceEvent } from '../../events/insurance/insurance_event';
import { InsuranceEventGenerator } from '../../events/insurance/insurance_event_generator';
import { Game } from '../../models/domain/game/game';

export class InsuranceGenerateRule extends Rule<InsuranceEvent.Event> {
  constructor(private config: RuleConfig, private insuranceInfo: InsuranceEvent.Info) {
    super();
  }

  getProbabilityLevel() {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return InsuranceEventGenerator.generate(game, this.insuranceInfo, this.getMaxHistoryLength());
  }

  getMinDistanceBetweenEvents() {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }

  getMaxHistoryLength() {
    return this.config.maxHistoryLength;
  }

  getType() {
    return InsuranceEvent.Type;
  }
}
