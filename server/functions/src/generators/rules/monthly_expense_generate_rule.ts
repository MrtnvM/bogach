import { Rule } from '../generator_rule';
import { MonthlyExpenseEvent } from '../../events/monthly_expense/monthly_expense_event';
import { ChildBornGenerator } from '../../events/monthly_expense/child_born/child_born_event_generator';
import { Game } from '../../models/domain/game/game';

export class MonthlyExpenseGenerateRule extends Rule<MonthlyExpenseEvent.Event> {
  getProbabilityLevel(): number {
    return 3;
  }

  generate(game: Game) {
    return ChildBornGenerator.generate();
  }

  getMinDistanceBetweenEvents(): number {
    return 2;
  }

  getType(): string {
    return MonthlyExpenseEvent.Type;
  }
}
