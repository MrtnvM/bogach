import { Rule, RuleConfig } from '../generator_rule';
import { IncomeEvent } from '../../events/income/income_event';
import { IncomeEventGenerator } from '../../events/income/income_event_generator';
import { Game } from '../../models/domain/game/game';

export class IncomeGenerateRule extends Rule<IncomeEvent.Event> {
  constructor(private config: RuleConfig, private incomeEvents: IncomeEvent.Info[]) {
    super();
  }

  getProbabilityLevel() {
    return this.config.probabilityLevel;
  }

  generate(game: Game) {
    return IncomeEventGenerator.generate(game, this.incomeEvents, this.getMaxHistoryLength());
  }

  getMinDistanceBetweenEvents(): number {
    return this.config.minDistanceBetweenEvents;
  }

  getMaxCountOfEventInMonth() {
    return this.config.maxCountOfEventInMonth;
  }

  getMaxHistoryLength() {
    return this.config.maxHistoryLength;
  }

  getType(): string {
    return IncomeEvent.Type;
  }
}
