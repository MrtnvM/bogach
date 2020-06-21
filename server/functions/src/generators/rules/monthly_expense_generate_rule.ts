import { Rule } from '../generator_rule';
import { MonthlyExpenseEvent } from '../../events/monthly_expense/monthly_expense_event';
import { ChildBornGenerator } from '../../events/monthly_expense/child_born/child_born_event_generator';
import { GameEvent } from '../../models/domain/game/game_event';

export class MonthlyExpenseGenerateRule extends Rule<MonthlyExpenseEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate(events: GameEvent[]) {
    return ChildBornGenerator.generate();
  }

  getMinDuration(): number {
    return 20;
  }

  getType(): string {
    return MonthlyExpenseEvent.Type;
  }
}
