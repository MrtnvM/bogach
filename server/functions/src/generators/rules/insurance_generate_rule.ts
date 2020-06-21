import { Rule } from '../generator_rule';
import { InsuranceEvent } from '../../events/insurance/insurance_event';
import { InsuranceEventGenerator } from '../../events/insurance/insurance_event_generator';

export class InsuranceGenerateRule extends Rule<InsuranceEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate() {
    return InsuranceEventGenerator.generate();
  }

  getMinDuration(): number {
    return 15;
  }

  getType(): string {
    return InsuranceEvent.Type;
  }
}
