import { Rule } from '../generator_rule';
import { InsuranceEvent } from '../../events/insurance/insurance_event';
import { InsuranceEventGenerator } from '../../events/insurance/insurance_event_generator';
import { Game } from '../../models/domain/game/game';

export class InsuranceGenerateRule extends Rule<InsuranceEvent.Event> {
  getProbabilityLevel(): number {
    return 5;
  }

  generate(game: Game) {
    return InsuranceEventGenerator.generate();
  }

  getMinDistanceBetweenEvents(): number {
    return 6;
  }

  getType(): string {
    return InsuranceEvent.Type;
  }
}
