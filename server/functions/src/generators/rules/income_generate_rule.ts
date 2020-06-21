import { Rule } from '../generator_rule';
import { IncomeEvent } from '../../events/income/income_event';
import { IncomeEventGenerator } from '../../events/income/income_event_generator';
import { GameEvent } from '../../models/domain/game/game_event';

export class IncomeGenerateRule extends Rule<IncomeEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate(events: GameEvent[]) {
    return IncomeEventGenerator.generate();
  }

  getMinDuration(): number {
    return 10;
  }

  getType(): string {
    return IncomeEvent.Type;
  }
}
