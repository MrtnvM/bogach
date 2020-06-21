import { Rule } from '../generator_rule';
import { ExpenseEvent } from '../../events/expense/expense_event';
import { ExpenseEventGenerator } from '../../events/expense/expense_event_generator';

export class ExpenseGenerateRule extends Rule<ExpenseEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate() {
    return ExpenseEventGenerator.generate();
  }

  getMinDuration(): number {
    return 10;
  }

  getType(): string {
    return ExpenseEvent.Type;
  }
}
