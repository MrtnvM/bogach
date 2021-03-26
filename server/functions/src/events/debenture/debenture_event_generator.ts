import * as uuid from 'uuid';
import * as random from 'random';
import { Strings } from '../../resources/strings';
import { DebentureEvent } from './debenture_event';
import { formatPrice } from '../../utils/currency';
import { Game, GameEntity } from '../../models/domain/game/game';
import { randomValueFromRange, ValueRange } from '../../core/data/value_range';

export namespace DebentureEventGenerator {
  export const generate = (game: Game): DebentureEvent.Event => {
    const debentureIndex = random.int(0, game.config.debentures.length - 1);
    const debenture = game.config.debentures[debentureIndex];

    const lastDebentureEvent = GameEntity.getLastEventOfType<DebentureEvent.Event>({
      game,
      type: DebentureEvent.Type,
    });

    const eventInfo: DebentureEvent.Info = {
      ...debenture,
      previousPrice: lastDebentureEvent?.data?.currentPrice,
    };

    const event = generateEvent(eventInfo);
    return event;
  };

  export const generateEvent = (eventInfo: DebentureEvent.Info): DebentureEvent.Event => {
    const { name, nominal, price, profitability, availableCount, previousPrice } = eventInfo;

    let currentPriceRange: ValueRange = price;

    if (previousPrice && previousPrice >= price.min && previousPrice <= price.max) {
      const maxPriceChangePercent = 0.04;

      currentPriceRange = {
        min: Math.max(previousPrice - previousPrice * maxPriceChangePercent, price.min),
        max: Math.min(previousPrice + previousPrice * maxPriceChangePercent, price.max),
        stepValue: price.stepValue,
      };
    }

    const currentPrice = randomValueFromRange(currentPriceRange);
    const currentNominal = randomValueFromRange(nominal);
    const currentProfitability = randomValueFromRange(profitability);
    const currentAvailableCount = randomValueFromRange(availableCount);

    return {
      id: uuid.v4(),
      name,
      description: Strings.currentPrice() + formatPrice(currentPrice),
      type: DebentureEvent.Type,
      data: {
        currentPrice,
        nominal: currentNominal,
        profitabilityPercent: currentProfitability,
        availableCount: currentAvailableCount,
      },
    };
  };
}
