import { Rule, RuleConfig } from '../generator_rule';
import { ExpenseEvent } from '../../events/expense/expense_event';
import { ExpenseEventGenerator } from '../../events/expense/expense_event_generator';
import { Game } from '../../models/domain/game/game';

export class ExpenseGenerateRule extends Rule<ExpenseEvent.Event> {
  constructor(private config: RuleConfig, private expenseEvents: ExpenseEvent.Info[]) {
    super();
  }

  getProbabilityLevel(): number {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return ExpenseEventGenerator.generate(game, this.expenseEvents);
  }

  getMinDistanceBetweenEvents(): number {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth ?? 0;
  }

  getType(): string {
    return ExpenseEvent.Type;
  }
}
