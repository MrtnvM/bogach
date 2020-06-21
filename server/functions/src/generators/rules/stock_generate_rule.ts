import { Rule } from '../generator_rule';
import { StockPriceChangedEvent } from '../../events/stock/stock_price_changed_event';
import { StockPriceChangedEventGenerator } from '../../events/stock/stock_price_changed_event_generator';

export class StockGenerateRule extends Rule<StockPriceChangedEvent.Event> {
  getPercentage(): number {
    return 10;
  }

  generate() {
    return StockPriceChangedEventGenerator.generate();
  }

  getMinDuration(): number {
    return 1;
  }

  getType(): string {
    return StockPriceChangedEvent.Type;
  }
}
