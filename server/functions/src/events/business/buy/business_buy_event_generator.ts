import * as uuid from 'uuid';
import * as random from 'random';
import { BusinessBuyEvent } from './business_buy_event';

// TODO добавить реальные данные
export namespace BusinessBuyEventGenerator {
  export const generate = (): BusinessBuyEvent.Event => {
    const businessId = uuid.v4();
    const currentPrice = random.int(70, 150) * 1000;
    const fairPrice = random.int(70, 150) * 1000;
    const downPayment = random.int(10, 25) * 1000;
    const debt = currentPrice - downPayment;
    const passiveIncomePerMonth = random.int(1, 3) * 1000;
    const incomePerYear = passiveIncomePerMonth * 12;
    const payBackValue = (incomePerYear / currentPrice) * 100;
    const payback = Math.round(payBackValue);
    const sellProbability = random.int(7, 13);

    return {
      id: uuid.v4(),
      name: 'Название бизнеса',
      description: 'Описание бизнеса',
      type: BusinessBuyEvent.Type,
      data: {
        businessId,
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
