import { Rule } from '../generator_rule';
import { IncomeEvent } from '../../events/income/income_event';
import { IncomeEventGenerator } from '../../events/income/income_event_generator';
import { Game } from '../../models/domain/game/game';

export class IncomeGenerateRule extends Rule<IncomeEvent.Event> {
  getProbabilityLevel(): number {
    return 10;
  }

  generate(game: Game) {
    return IncomeEventGenerator.generate();
  }

  getMinDistanceBetweenEvents(): number {
    return 10;
  }

  getType(): string {
    return IncomeEvent.Type;
  }
}
