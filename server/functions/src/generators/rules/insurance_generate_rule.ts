import { Rule, RuleConfig } from '../generator_rule';
import { InsuranceEvent } from '../../events/insurance/insurance_event';
import { InsuranceEventGenerator } from '../../events/insurance/insurance_event_generator';
import { Game } from '../../models/domain/game/game';

export class InsuranceGenerateRule extends Rule<InsuranceEvent.Event> {
  constructor(private config: RuleConfig, private insuranceInfo: InsuranceEvent.Info) {
    super();
  }

  getProbabilityLevel(): number {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return InsuranceEventGenerator.generate(game, this.insuranceInfo);
  }

  getMinDistanceBetweenEvents(): number {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxCountOfEventInMonth(): number {
    return this.config.maxCountOfEventInMonth ?? 0;
  }

  getType(): string {
    return InsuranceEvent.Type;
  }
}
