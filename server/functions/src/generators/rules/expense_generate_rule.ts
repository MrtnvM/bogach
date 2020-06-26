import { Rule } from '../generator_rule';
import { ExpenseEvent } from '../../events/expense/expense_event';
import { ExpenseEventGenerator } from '../../events/expense/expense_event_generator';
import { Game } from '../../models/domain/game/game';

export class ExpenseGenerateRule extends Rule<ExpenseEvent.Event> {
  getProbabilityLevel(): number {
    return 4;
  }

  generate(game: Game) {
    return ExpenseEventGenerator.generate();
  }

  getMinDistanceBetweenEvents(): number {
    return 2;
  }

  getType(): string {
    return ExpenseEvent.Type;
  }
}
