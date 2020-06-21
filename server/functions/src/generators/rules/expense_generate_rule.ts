import { Rule } from '../generator_rule';
import { ExpenseEvent } from '../../events/expense/expense_event';
import { ExpenseEventGenerator } from '../../events/expense/expense_event_generator';
import { GameEvent } from '../../models/domain/game/game_event';

export class ExpenseGenerateRule extends Rule<ExpenseEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate(events: GameEvent[]) {
    return ExpenseEventGenerator.generate();
  }

  getMinDuration(): number {
    return 10;
  }

  getType(): string {
    return ExpenseEvent.Type;
  }
}
