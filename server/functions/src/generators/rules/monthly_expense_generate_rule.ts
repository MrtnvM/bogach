import { Rule, RuleConfig } from '../generator_rule';
import { MonthlyExpenseEvent } from '../../events/monthly_expense/monthly_expense_event';
import { ChildBornGenerator } from '../../events/monthly_expense/child_born/child_born_event_generator';
import { Game } from '../../models/domain/game/game';

export class MonthlyExpenseGenerateRule extends Rule<MonthlyExpenseEvent.Event> {
  constructor(private config: RuleConfig) {
    super();
  }

  getProbabilityLevel() {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return ChildBornGenerator.generate(game);
  }

  getMinDistanceBetweenEvents() {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxHistoryLength() {
    return this.config.maxHistoryLength;
  }

  getType() {
    return MonthlyExpenseEvent.Type;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }
}
