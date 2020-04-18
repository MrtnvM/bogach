import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { formatPrice } from '../../utils/currency';
import { StockPriceChangedEvent } from './stock_price_changed_event';

export namespace StockPriceChangedEventGenerator {
  export const generate = (): StockPriceChangedEvent.Event => {
      // params value?
    const fairPrice = random.int(20, 100);
    const priceDifference = random.int(-20, 20) * fairPrice;
    // TODO when we should generate current price
    const currentPrice = fairPrice + priceDifference;
    // TODO stub now.
    const portfolioCount = 0;
    const maxCount = random.int(9, 14) * 10;

    return {
      id: uuid.v4(),
      name: Strings.stocksTitle(),
      description: Strings.currentPrice() + formatPrice(currentPrice),
      type: StockPriceChangedEvent.Type,
      data: {
        currentPrice,
        fairPrice,
        portfolioCount,
        maxCount,
      },
    };
  };
}
