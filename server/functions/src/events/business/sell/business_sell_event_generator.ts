import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { formatPrice } from '../../utils/currency';
import { BusinessOfferEvent } from './business_offer_event';

export namespace BusinessOfferEventGenerator {
  export const generate = (): BusinessOfferEvent.Event => {
    const currentPrice = random.int(7, 15) * 1000;
    const fairPrice = random.int(7, 15) * 1000;
    const downPayment = random.int(10, 25) * 1000;
    const debt = currentPrice - downPayment;
    const passiveIncomePerMonth = random.int(1, 3) * 1000;
    const incomePerYear = passiveIncomePerMonth * 12;
    const payback = (incomePerYear / currentPrice) * 100;
    const sellProbability = random.int(7, 13);

    return {
      id: uuid.v4(),
      name: 'Название бизнеса',
      description: Strings.currentPrice() + formatPrice(currentPrice),
      type: BusinessOfferEvent.Type,
      data: {
        currentPrice,
        fairPrice,
        downPayment,
        debt,
        passiveIncomePerMonth,
        payback,
        sellProbability,
      },
    };
  };
}
