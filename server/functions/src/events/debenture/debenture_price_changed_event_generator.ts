import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { DebenturePriceChangedEvent } from './debenture_price_changed_event';
import { formatPrice } from '../../utils/currency';

export namespace DebenturePriceChangedEventGenerator {
  export const generate = (): DebenturePriceChangedEvent.Event => {
    const currentPrice = random.int(8, 13) * 100;
    const nominal = 1000;
    const profitabilityPercent = random.int(6, 10);
    const maxCount = random.int(9, 14) * 10;

    return {
      id: uuid.v4(),
      name: Strings.debeturesTitle(),
      description: Strings.currentPrice() + formatPrice(currentPrice),
      type: DebenturePriceChangedEvent.Type,
      data: {
        currentPrice,
        nominal,
        profitabilityPercent,
        availableCount: maxCount,
      },
    };
  };
}
