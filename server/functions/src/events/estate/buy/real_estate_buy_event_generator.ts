import { BuyRealEstateEvent } from './real_estate_buy_event';
import { Game, GameEntity } from '../../../models/domain/game/game';
import { BuyRealEstateGeneratorConfig } from './real_estate_buy_generator_config';
import uuid = require('uuid');
import * as random from 'random';
import { randomValueFromRange } from '../../../core/data/value_range';

export namespace BuyRealEstateEventGenerator {
  export const generate = (game: Game): BuyRealEstateEvent.Event | undefined => {
    const pastBuyRealEstateEvents = GameEntity.getPastEventsOfType<BuyRealEstateEvent.Event>({
      game,
      type: BuyRealEstateEvent.Type,
      maxHistoryLength: 6,
    });

    const alreadyHappenedEvents = {};
    pastBuyRealEstateEvents.forEach((e) => (alreadyHappenedEvents[e.name] = true));

    let filtredBuyRealEstateEvents = BuyRealEstateGeneratorConfig.allRealEstates.filter(
      (e) => !alreadyHappenedEvents[e.eventName]
    );

    const lastEvent = pastBuyRealEstateEvents[0];
    if (lastEvent) {
      filtredBuyRealEstateEvents = filtredBuyRealEstateEvents.filter(
        (e) => e.eventName === lastEvent.name
      );
    }

    if (filtredBuyRealEstateEvents.length === 0) {
      return undefined;
    }

    const eventIndex = random.int(0, filtredBuyRealEstateEvents.length - 1);
    const eventInfo = filtredBuyRealEstateEvents[eventIndex];

    const currentPrice = randomValueFromRange(eventInfo.price);
    const fairPrice = randomValueFromRange(eventInfo.fairPrice);

    const downPayment = randomValueFromRange(eventInfo.downPayment);
    const debt = currentPrice - downPayment;

    const passiveIncomePerMonth = randomValueFromRange(eventInfo.passiveIncomePerMonth);

    const incomePerYear = passiveIncomePerMonth * 12;
    const payBackValue = (incomePerYear / currentPrice) * 100;
    const payback = Math.round(payBackValue);

    const sellProbability = randomValueFromRange(eventInfo.sellProbability);

    return {
      id: uuid.v4(),
      name: eventInfo.eventName,
      type: BuyRealEstateEvent.Type,
      description: '',
      data: {
        realEstateId: uuid.v4(),
        currentPrice: currentPrice,
        fairPrice: fairPrice,
        downPayment: downPayment,
        debt: debt,
        passiveIncomePerMonth: passiveIncomePerMonth,
        payback: payback,
        sellProbability: sellProbability,
        assetName: eventInfo.assetName,
      },
    };
  };
}
