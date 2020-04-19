import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { formatPrice } from '../../utils/currency';
import { StockPriceChangedEvent } from './stock_price_changed_event';

export namespace StockPriceChangedEventGenerator {
  export const generate = (): StockPriceChangedEvent.Event => {
    const fairPrice = random.int(20, 100);
    const minPercentRange = -0.3;
    const maxPercentRange = 0.3;
    const priceDifference = random.int(minPercentRange, maxPercentRange) * fairPrice;
    const currentPrice = fairPrice + priceDifference;
    const maxCount = random.int(9, 14) * 10;

    return {
      id: uuid.v4(),
      name: Strings.stocksTitle(),
      description: Strings.currentPrice() + formatPrice(currentPrice),
      type: StockPriceChangedEvent.Type,
      data: {
        currentPrice,
        fairPrice,
        maxCount,
      },
    };
  };
}
