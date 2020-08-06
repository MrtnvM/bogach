import * as uuid from 'uuid';
import { BusinessBuyEvent } from './business_buy_event';
import { randomValueFromRange, valueRange } from '../../../core/data/value_range';

// TODO добавить реальные данные
export namespace BusinessBuyEventGenerator {
  export const generate = (): BusinessBuyEvent.Event => {
    const businessId = uuid.v4();

    return generateEvent({
      name: 'Название бизнеса',
      description: 'Описание бизнеса',
      businessId,
      currentPrice: valueRange([70_000, 150_000, 1_000]),
      fairPrice: valueRange([70_000, 150_000, 1_000]),
      downPayment: valueRange([10_000, 25_000, 1_000]),
      passiveIncomePerMonth: valueRange([1_000, 5_000, 500]),
      sellProbability: valueRange([3, 15, 1]),
    });
  };

  export const generateEvent = (businessInfo: BusinessBuyEvent.Info): BusinessBuyEvent.Event => {
    const {
      name,
      description,
      businessId,
      currentPrice,
      fairPrice,
      downPayment,
      passiveIncomePerMonth,
      sellProbability,
    } = businessInfo;

    const currentPriceValue = randomValueFromRange(currentPrice);
    const fairPriceValue = randomValueFromRange(fairPrice);
    const downPaymentValue = randomValueFromRange(downPayment);
    const passiveIncomePerMonthValue = randomValueFromRange(passiveIncomePerMonth);
    const sellProbabilityValue = randomValueFromRange(sellProbability);

    const debt = currentPriceValue - downPaymentValue;
    const incomePerYear = passiveIncomePerMonthValue * 12;
    const payBackValue = (incomePerYear / currentPriceValue) * 100;
    const payback = Math.round(payBackValue);

    return {
      id: uuid.v4(),
      name,
      description,
      type: BusinessBuyEvent.Type,
      data: {
        businessId,
        currentPrice: currentPriceValue,
        fairPrice: fairPriceValue,
        downPayment: downPaymentValue,
        debt,
        passiveIncomePerMonth: passiveIncomePerMonthValue,
        payback,
        sellProbability: sellProbabilityValue,
      },
    };
  };
}
