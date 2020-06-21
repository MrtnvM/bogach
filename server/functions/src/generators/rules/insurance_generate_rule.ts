import { Rule } from '../generator_rule';
import { InsuranceEvent } from '../../events/insurance/insurance_event';
import { InsuranceEventGenerator } from '../../events/insurance/insurance_event_generator';
import { GameEvent } from '../../models/domain/game/game_event';

export class InsuranceGenerateRule extends Rule<InsuranceEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate(events: GameEvent[]) {
    return InsuranceEventGenerator.generate();
  }

  getMinDuration(): number {
    return 15;
  }

  getType(): string {
    return InsuranceEvent.Type;
  }
}
