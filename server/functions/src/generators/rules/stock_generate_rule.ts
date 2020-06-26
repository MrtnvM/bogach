import { Rule } from '../generator_rule';
import { StockPriceChangedEvent } from '../../events/stock/stock_price_changed_event';
import { StockPriceChangedEventGenerator } from '../../events/stock/stock_price_changed_event_generator';
import { Game } from '../../models/domain/game/game';

export class StockGenerateRule extends Rule<StockPriceChangedEvent.Event> {
  getProbabilityLevel(): number {
    return 10;
  }

  generate(game: Game) {
    return StockPriceChangedEventGenerator.generate(game);
  }

  getMinDistanceBetweenEvents(): number {
    return 0;
  }

  getType(): string {
    return StockPriceChangedEvent.Type;
  }

  getMaxCountOfEventInMonth() {
    return 3;
  }
}
