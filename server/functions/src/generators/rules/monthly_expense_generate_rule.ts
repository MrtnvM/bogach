import { Rule } from '../generator_rule';
import { MonthlyExpenseEvent } from '../../events/monthly_expense/monthly_expense_event';
import { ChildBornGenerator } from '../../events/monthly_expense/child_born/child_born_event_generator';

export class MonthlyExpenseGenerateRule extends Rule<MonthlyExpenseEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate() {
    return ChildBornGenerator.generate();
  }

  getMinDuration(): number {
    return 20;
  }

  getType(): string {
    return MonthlyExpenseEvent.Type;
  }
}
