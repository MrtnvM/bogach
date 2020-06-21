import { Rule } from '../generator_rule';
import { IncomeEvent } from '../../events/income/income_event';
import { IncomeEventGenerator } from '../../events/income/income_event_generator';

export class IncomeGenerateRule extends Rule<IncomeEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate() {
    return IncomeEventGenerator.generate();
  }

  getMinDuration(): number {
    return 10;
  }

  getType(): string {
    return IncomeEvent.Type;
  }
}
