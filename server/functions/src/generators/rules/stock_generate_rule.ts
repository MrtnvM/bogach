import { Rule } from '../generator_rule';
import { StockEvent } from '../../events/stock/stock_event';
import { StockEventGenerator } from '../../events/stock/stock_event_generator';
import { Game } from '../../models/domain/game/game';

export class StockGenerateRule extends Rule<StockEvent.Event> {
  getProbabilityLevel(): number {
    return 10;
  }

  generate(game: Game) {
    return StockEventGenerator.generate(game);
  }

  getMinDistanceBetweenEvents(): number {
    return 0;
  }

  getType(): string {
    return StockEvent.Type;
  }

  getMaxCountOfEventInMonth() {
    return 3;
  }
}
